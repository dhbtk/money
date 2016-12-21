class Statement < ApplicationRecord
  belongs_to :account
  belongs_to :tag, optional: true

  def self.search(term)
  	  left_outer_joins(:tag).where('unaccent("statements"."name") ILIKE unaccent(?) OR unaccent("tags"."name") ILIKE unaccent (?)', "%#{term}%", "%#{term}%")
  end

  def self.skip_transfer_debits
    where.not('"statements"."id" IN (SELECT debit_id FROM transfers JOIN statements c ON credit_id = c.id JOIN accounts a ON c.account_id = a.id WHERE a.user_id = "accounts"."user_id")')
  end

  def self.debits
    where type: 'Debit'
  end

  def self.credits(user)
    where(type: 'Credit', recurring_credit_id: nil).where.not(id: user.bills.where.not(credit_id: nil).pluck(:credit_id) + user.transfers.pluck(:credit_id))
  end

  def self.recurring_credits
    where(type: 'Credit').where.not recurring_credit_id: nil
  end

  def self.bill_credits(user)
    where type: 'Credit', id: user.bills.where.not(credit_id: nil).pluck(:credit_id)
  end

  def self.transfers(user)
    where id: user.transfers.pluck(:credit_id)
  end
end
