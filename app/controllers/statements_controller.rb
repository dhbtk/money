class StatementsController < ApplicationController
  def index
    @accounts = Account.all
    @statements = Statement.all
  end

  def new
  end
end
