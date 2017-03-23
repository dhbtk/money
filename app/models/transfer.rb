# == Schema Information
#
# Table name: transfers
#
#  id          :integer          not null, primary key
#  debit_id    :integer
#  credit_id   :integer
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_transfers_on_credit_id  (credit_id)
#  index_transfers_on_debit_id   (debit_id)
#

class Transfer < ApplicationRecord
  audited
  belongs_to :debit, autosave: true
  belongs_to :credit, autosave: true

  attr_writer :source_account, :destination_account, :value, :date

  validate :values_must_be_the_same
  validates :source_account, :destination_account, :value, :date, presence: true
  validates :value, numericality: { greater_than: 0 }

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

  after_initialize do
    self.date ||= Date.today
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
    self.credit.name = description
    self.debit.name = description
  end

  def values_must_be_the_same
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
      transfer.description = credit.name
      transfer.build_debit(account: account, date: credit.date, value: credit.value, name: credit.name)
    end
    transfer
  end
end
