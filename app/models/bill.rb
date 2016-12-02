class Bill < ApplicationRecord
  belongs_to :billing_account

  after_initialize do
    self.expiration ||= DateTime.now.to_date
  end
end
