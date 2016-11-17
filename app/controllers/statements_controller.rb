class StatementsController < ApplicationController
  def index
    @accounts = current_user.accounts
    @statements = Statement.by_user(current_user)
  end

  def new
  end
end
