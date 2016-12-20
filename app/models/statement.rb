class Statement < ApplicationRecord
  belongs_to :account
  belongs_to :tag, optional: true

  def self.search(term)
  	  left_outer_joins(:tag).where('unaccent("statements"."name") ILIKE unaccent(?) OR unaccent("tags"."name") ILIKE unaccent (?)', "%#{term}%", "%#{term}%")
  end

  def self.skip_transfer_debits
    where.not('"statements"."id" IN (SELECT debit_id FROM transfers JOIN statements c ON credit_id = c.id JOIN accounts a ON c.account_id = a.id WHERE a.user_id = "accounts"."user_id")')
  end
end
