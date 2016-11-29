class Statement < ApplicationRecord
  belongs_to :account
  belongs_to :tag, optional: true

  def self.by_date(user, from, to)
    all(user, from, to).group_by { |x| x.date.to_date }
  end

  def self.grid(scope, from = 15.days.ago, to = 15.days.from_now)
    statements = scope.map { |acc| [acc, acc.statements(from, to)] }.to_h
    statements.values.map { |x| x.keys }.flatten.uniq.sort
        .map { |date| [date, statements.to_a.map { |st| [st[0], st[1][date]] }] }
  end
end
