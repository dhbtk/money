class Statement
  def self.all(from = 15.days.ago, to = 15.days.from_now)
    statements = Debit.where('"date" <= ? AND "date" >= ?', to, from) + Credit.where('"date" <= ? AND "date" >= ?', to, from)
    statements.sort{ |a, b| a.date <=> b.date }.group_by{ |x| x.date.to_date }
  end

  def self.grid(scope = Account.all, from = 15.days.ago, to = 15.days.from_now)
    statements = scope.map{|acc| [acc, acc.statements(from, to)]}.to_h
    statements.values.map{ |x| x.keys }.flatten.uniq.sort
        .map{ |date| [date, statements.to_a.map{ |st| [st[0], st[1][date]] }] }
  end
end
