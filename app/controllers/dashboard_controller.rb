class DashboardController < AuthenticatedController
  def show
    @spending = current_user.spending(30)
    @latest_spending = current_user.credits.includes(:category).except(:order).where('"date" <= ?', Date.today).where.not(id: current_user.transfers.pluck(:credit_id)).order(date: :desc, created_at: :desc).limit(15)
    @categories = current_user.categories.with_recent_spending
    @spending_calendar = current_user.spending_calendar
    @bills = current_user.bills.where('date(expiration) <= ?', 15.days.from_now).where(credit_id: nil)
  end

  def calendar
    @today = Date.new(params[:year].to_i, params[:month].to_i, 1)
    if @today.month == Date.today.month && @today.year == Date.today.year
      @today = Date.today
    end
    @spending_calendar = current_user.spending_calendar @today
    respond_to do |format|
      format.js
    end
  end
end
