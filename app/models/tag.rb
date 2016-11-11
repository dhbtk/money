class Tag < ApplicationRecord
  has_many :credits
  has_many :debits

  validates :name, presence: true, uniqueness: true
end
