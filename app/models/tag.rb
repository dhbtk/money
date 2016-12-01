class Tag < ApplicationRecord
  self.sync_selectors = [
      {joins: nil, where: nil}
  ]
  belongs_to :user

  has_many :credits
  has_many :debits

  validates :name, presence: true, uniqueness: { scope: :user_id }
end
