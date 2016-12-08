class DashboardController < AuthenticatedController
  def show
    @spending = current_user.spending(30)
    @latest_spending = current_user.credits.except(:order).where('"date" <= ?', Date.today).where.not(id: current_user.transfers.pluck(:credit_id)).order(date: :desc, created_at: :desc).limit(15)
    @tags = current_user.tags
  end
end
