class DashboardController < ApplicationController
  def show
    respond_to do |format|
      format.html do
        if current_user.nil?
          redirect_to new_user_session_path
          return
        end
      end
      format.json do
        if current_user.nil?
          authenticate_user!
          return
        end
      end
    end
    @spending = current_user.spending(30)
    @latest_spending = current_user.credits.except(:order).where('"date" <= ?', Date.today).where.not(id: current_user.transfers.pluck(:credit_id)).order(date: :desc, created_at: :desc).limit(15)
    @tags = current_user.tags
  end
end
