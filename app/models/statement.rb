class Statement
  def self.by_user(user, from = 15.days.ago, to = 15.days.from_now)
  	  debits = Debit.joins(:account).where(accounts: { user_id: user })
  	  credits = Credit.joins(:account).where(accounts: { user_id: user })
      statements = debits.where('"date" <= ? AND "date" >= ?', to, from).includes(:transfer) + credits.where('"date" <= ? AND "date" >= ?', to, from).includes(:transfer)
    statements.sort{ |b, a| r = a.date <=> b.date; r == 0 ? a.created_at <=> b.created_at : r }.group_by{ |x| x.date.to_date }
  end

  def self.grid(scope, from = 15.days.ago, to = 15.days.from_now)
    statements = scope.map{|acc| [acc, acc.statements(from, to)]}.to_h
    statements.values.map{ |x| x.keys }.flatten.uniq.sort
        .map{ |date| [date, statements.to_a.map{ |st| [st[0], st[1][date]] }] }
  end
end
