class StatementsController < ApplicationController
  def index
    @accounts = Account.all
    @statements = Account.statements_grid(@accounts)
  end

  def new
  end
end
