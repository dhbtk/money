class StatementsController < ApplicationController
  def index
    @accounts = current_user.accounts
    @statements = Statement.by_user(current_user, 30.days.ago)
  end

  def new
    @credit = Credit.new
    @debit = Debit.new
    @transfer = Transfer.new
  end
end
