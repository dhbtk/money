class Debit < Statement

  has_one :transfer, dependent: :destroy

  validates :date, :value, presence: true

  after_initialize do
    self.date ||= DateTime.now.to_date
  end
end
