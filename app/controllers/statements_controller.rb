class StatementsController < ApplicationController
  def index
    @from = params[:from].present? ? params[:from] : 7.days.ago.to_date
    @to = params[:to].present? ? params[:to] : DateTime.now.to_date
    @statements = Statement.by_user(current_user, @from, @to)
  end

  def graph
    @credits = current_user.credits.where('"date" >= ? AND "date" <= ?', DateTime.now.beginning_of_month, DateTime.now.to_date).where.not(id: current_user.transfers.pluck(:credit_id))
    @debits = current_user.debits.where('"date" >= ? AND "date" <= ?', DateTime.now.beginning_of_month, DateTime.now.to_date).where.not(id: current_user.transfers.pluck(:debit_id))
  end
end
