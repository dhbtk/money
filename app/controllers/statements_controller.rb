class StatementsController < ApplicationController
  def index
    @from = params[:from].present? ? params[:from] : 1.days.ago.to_date
    @to = params[:to].present? ? params[:to] : DateTime.now.to_date
    @accounts = current_user.accounts
    @statements = Statement.by_user(current_user, @from, @to)
  end
end
