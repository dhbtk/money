class StatementsController < AuthenticatedController
  def index
    @periods = {
        'Semana atual' => 'week',
        'Mês atual' => 'month',
        'Últimos três meses' => 'trimester',
        'Todos até hoje' => 'past',
        'Futuros' => 'future'
    }
    @selected_period = params[:period].present? ? params[:period] : (session[:statements_period] || 'week')
    @statements = current_user.statements
    case @selected_period
      when 'week'
        @from = DateTime.now.beginning_of_week
        @to = DateTime.now.to_date
      when 'month'
        @from = DateTime.now.beginning_of_month
        @to = DateTime.now.to_date
      when 'trimester'
        @from = (DateTime.now - 2.months).beginning_of_month
        @to = DateTime.now.to_date
      when 'future'
        @from = DateTime.now.to_date + 1.day
        @to = nil
      when 'past'
        @to = DateTime.now.to_date
        @from = nil
      else
        @from = nil
        @to = nil
    end

    @search = !params[:search].nil? ? params[:search] : session[:statements_search]
    @account_id = !params[:account_id].nil? ? params[:account_id] : session[:statements_account_id]
    @statements = @statements.where('"date" >= ?', @from.to_date) if @from
    @statements = @statements.where('"date" <= ?', @to.to_date) if @to
    @statements = @statements.where(account_id: @account_id) if @account_id.present?
    @statements = @statements.left_outer_joins(:tag).where('unaccent("statements"."name") ILIKE unaccent(?) OR unaccent("tags"."name") ILIKE unaccent (?) OR "statements"."name" IS NULL', "%#{@search}%", "%#{@search}%")
    @statements = @statements.includes(:tag, :account).order(date: :desc, created_at: :desc).page(params[:page])

    @accounts = current_user.accounts.order(:name)

    session[:statements_period] = @selected_period
    session[:statements_search] = @search
    session[:statements_account_id] = @account_id
  end

  def graph
    @credits = current_user.credits.where('"date" >= ? AND "date" <= ?', (DateTime.now - 30.days).to_date, DateTime.now.to_date).where.not(id: current_user.transfers.pluck(:credit_id))
    @debits = current_user.debits.where('"date" >= ? AND "date" <= ?', (DateTime.now - 30.days).to_date, DateTime.now.to_date).where.not(id: current_user.transfers.pluck(:debit_id))
    @from = params[:from].present? ? params[:from] : 7.days.ago.to_date
    @to = DateTime.now.to_date
    @statements = current_user.statements.where('"date" >= ? AND "date" <= ?', @from, @to).order(date: :desc, created_at: :desc).group_by{|x| x.date}
  end
end
