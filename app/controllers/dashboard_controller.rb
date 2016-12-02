class DashboardController < ApplicationController
  def show
    @spending = current_user.spending(30)
    @latest_spending = current_user.credits.where.not(id: current_user.transfers.pluck(:credit_id)).limit(15)
  end
end
