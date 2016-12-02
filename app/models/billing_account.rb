class BillingAccount < ApplicationRecord
  belongs_to :user
  has_many :bills, -> { order(expiration: :desc, created_at: :desc) }, dependent: :destroy

  validates :name, presence: true
end
