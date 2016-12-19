class Statement < ApplicationRecord
  belongs_to :account
  belongs_to :tag, optional: true

  def self.search(term)
  	  left_outer_joins(:tag).where('unaccent("statements"."name") ILIKE unaccent(?) OR unaccent("tags"."name") ILIKE unaccent (?) OR "statements"."name" IS NULL', "%#{term}%", "%#{term}%")
  end
end
