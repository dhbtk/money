class Tag < ApplicationRecord
  has_many :credits
  has_many :debits
end
