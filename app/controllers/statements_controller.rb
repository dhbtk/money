class StatementsController < AuthenticatedController
  def index
    @periods = {
        'Semana atual' => 'week',
        'Mês atual' => 'month',
        'Últimos três meses' => 'trimester',
        'Todos até hoje' => 'past',
        'Futuros' => 'future'
    }
    @types = {
        'Todos' => '',
        'Receitas' => 'debit',
        'Despesas' => 'credit',
        'Contas pagas' => 'bill',
        'Parcelamentos' => 'recurring_credit',
        'Transferências' => 'transfer'
    }
    @selected_period = params[:period].present? ? params[:period] : (session[:statements_period] || 'week')
    @type = !params[:type].nil? ? params[:type] : (session[:statements_type] || '')

    @statements = current_user.statements.skip_transfer_debits
    case @selected_period
      when 'week'
        @from = Date.today - 7.days
        @to = Date.today
      when 'month'
        @from = DateTime.now - (Date.today.end_of_month.day).days
        @to = Date.today
      when 'trimester'
        @from = DateTime.now - 3.months
        @to = Date.today
      when 'future'
        @from = Date.today + 1.day
        @to = nil
      when 'past'
        @to = Date.today
        @from = nil
      else
        @from = nil
        @to = nil
    end
    case @type
      when 'debit'
        @statements = @statements.debits
      when 'credit'
        @statements = @statements.credits current_user
      when 'bill'
        @statements = @statements.bill_credits current_user
      when 'recurring_credit'
        @statements = @statements.recurring_credits
      when 'transfer'
        @statements = @statements.transfers current_user
      else
        @statements = @statements
    end
    @statements = @statements.where('date("date") >= ?', @from.to_date) if @from
    @statements = @statements.where('date("date") <= ?', @to.to_date) if @to

    @account_id = !params[:account_id].nil? ? params[:account_id] : session[:statements_account_id]
    @statements = @statements.where(account_id: @account_id) if @account_id.present?

    @search = !params[:search].nil? ? params[:search] : session[:statements_search]
    @statements = @statements.search(@search) unless @search.blank?

    @statements = @statements.includes(:transfer, :category, :account).order(date: :desc, created_at: :desc).page(params[:page])

    @accounts = current_user.accounts.order(:name)

    session[:statements_period] = @selected_period
    session[:statements_search] = @search
    session[:statements_account_id] = @account_id
    session[:statements_type] = @type
  end

  def report
    @date = params[:date].present? ? params[:date] : Date.today
    @report = StatementReport.new(current_user, @date)
  end
end
