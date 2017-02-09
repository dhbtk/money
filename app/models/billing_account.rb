class BillingAccount < ApplicationRecord
  audited
  belongs_to :user
  has_many :bills, -> { order(expiration: :desc, created_at: :asc) }, dependent: :destroy

  validates :name, presence: true
end
