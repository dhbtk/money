class Transfer < ApplicationRecord
  belongs_to :debit
  belongs_to :credit

  validate :debit_and_credit_value_must_be_the_same

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
