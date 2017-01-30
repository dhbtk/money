class StatementReport
  attr_reader :user, :date

  def initialize(user, date)
    @user = user
    @date = date.to_date
  end

  def total_spending
    @total_spending ||= @user.credits.where.not(id: @user.transfers.pluck(:credit_id)).where('date(date) >= ? AND date(date) <= ?', @date.beginning_of_month, @date.end_of_month).sum(:value)
  end

  def total_earning
    @total_earning ||= @user.debits.where.not(id: @user.transfers.pluck(:debit_id)).where('date(date) >= ? AND date(date) <= ?', @date.beginning_of_month, @date.end_of_month).sum(:value)
  end

  def spending_by_categories
    categories = @user.categories
    total = []
    categories.each do |category|
      sum = @user.credits.where.not(id: @user.transfers.pluck(:credit_id))
                .where('date(date) >= ? AND date(date) <= ?', @date.beginning_of_month, @date.end_of_month)
                .where(category_id: category.id)
                .sum(:value)
      total << [category, sum] if sum > 0
    end
    total.sort do |b, a|
      a[1] <=> b[1]
    end.to_h
  end

  def earning_by_categories
    categories = @user.categories
    total = []
    categories.each do |category|
      sum = @user.debits.where.not(id: @user.transfers.pluck(:debit_id))
                .where('date(date) >= ? AND date(date) <= ?', @date.beginning_of_month, @date.end_of_month)
                .where(category_id: category.id)
                .sum(:value)
      total << [category, sum] if sum > 0
    end
    total.sort do |b, a|
      a[1] <=> b[1]
    end.to_h
  end
end
