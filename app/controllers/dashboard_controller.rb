class DashboardController < AuthenticatedController
  def show
    @spending = current_user.spending(30)
    @latest_spending = current_user.credits.includes(:tag).except(:order).where('"date" <= ?', Date.today).where.not(id: current_user.transfers.pluck(:credit_id)).order(date: :desc, created_at: :desc).limit(15)
    @tags = current_user.tags.with_recent_spending
    @spending_calendar = current_user.spending_calendar
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
