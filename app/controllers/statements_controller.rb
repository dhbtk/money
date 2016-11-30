class StatementsController < ApplicationController
  def index
    @options = {
        'Semana atual' => 'week',
        'Mês atual' => 'month',
        'Últimos três meses' => 'trimester',
        'Futuros' => 'future'
    }
    @selected_option = params[:option].present? ? params[:option] : 'week'
    @statements = current_user.statements
    case @selected_option
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
      else
        @from = nil
        @to = nil
    end
    @statements = @statements.where('"date" >= ?', @from.to_date) if @from
    @statements = @statements.where('"date" <= ?', @to.to_date) if @to
    @statements = @statements.where(account_id: params[:account_id]) if params[:account_id].present?
    @statements = @statements.order(date: :desc, created_at: :desc).page(params[:page])
  end

  def graph
    @credits = current_user.credits.where('"date" >= ? AND "date" <= ?', DateTime.now.beginning_of_month, DateTime.now.to_date).where.not(id: current_user.transfers.pluck(:credit_id))
    @debits = current_user.debits.where('"date" >= ? AND "date" <= ?', DateTime.now.beginning_of_month, DateTime.now.to_date).where.not(id: current_user.transfers.pluck(:debit_id))
    @from = params[:from].present? ? params[:from] : 7.days.ago.to_date
    @to = DateTime.now.to_date
    @statements = current_user.statements.where('"date" >= ? AND "date" < ?', @from, @to).order(date: :desc, created_at: :desc).group_by{|x| x.date}
  end
end
