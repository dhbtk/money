class Bill < ApplicationRecord
  belongs_to :billing_account
  belongs_to :credit, optional: true
  validates :name, presence: true

  def pay(account)
    self.credit = account.credits.build(value: value, name: name)
    self.credit.save
    save
  end

end
