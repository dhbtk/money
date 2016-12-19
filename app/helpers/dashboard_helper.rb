module DashboardHelper
  def calendar_percent(value, max = 300)
    return 0 if max == 0
    percent = (value/max)*100
    percent > 100 ? 100 : percent
  end

  def calendar_path(date)
    '/dashboard/calendar/' + date.year.to_s + '/' + date.month.to_s
  end
end
