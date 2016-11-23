class Tag < ApplicationRecord
  self.sync_selectors = [
      {joins: nil, where: nil}
  ]
  has_many :credits
  has_many :debits

  validates :name, presence: true, uniqueness: true
end
