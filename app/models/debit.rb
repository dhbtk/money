class Debit < Statement
  self.sync_selectors = [
      {joins: :account, where: {accounts: {user_id: :x}}}
  ]

  has_one :transfer, dependent: :destroy

  validates :date, :value, presence: true

  after_initialize do
    self.date ||= DateTime.now.to_date
  end
end
