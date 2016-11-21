class Transfer < ApplicationRecord
  belongs_to :debit
  belongs_to :credit

  attr_writer :source_account, :destination_account, :value, :date, :description

  validate :debit_and_credit_value_must_be_the_same
  validates :source_account, :destination_account, :value, :date, presence: true

  def source_account
    @source_account ||= credit&.account
  end

  def source_account_id
    source_account&.id
  end

  def source_account_id=(val)
    @source_account = Account.find(val)
  end

  def destination_account
    @destination_account ||= debit&.account
  end

  def destination_account_id
    destination_account&.id
  end

  def destination_account_id=(val)
    @destination_account = Account.find(val)
  end

  def value
    @value ||= credit&.value
  end

  def date
    @date ||= credit&.date
  end

  before_validation do
    self.credit ||= Credit.new
    self.debit ||= Debit.new
    self.credit.account = source_account
    self.debit.account = destination_account
    self.credit.date = date
    self.debit.date = date
    self.credit.value = value
    self.debit.value = value
  end

  def debit_and_credit_value_must_be_the_same
    unless debit.present? && credit.present? && debit.value == credit.value
      errors.add(:base, 'Debit and credit values must be the same')
    end
  end

  def self.from_credit_and_account(credit, account)
    transfer = Transfer.new
    if account.id == credit.account_id
      credit.errors.add(:base, 'Não é permitido transferir para a mesma conta.')
    else
      transfer.credit = credit
      transfer.build_debit(account: account, date: credit.date, value: credit.value, name: credit.name)
    end
    transfer
  end
end
