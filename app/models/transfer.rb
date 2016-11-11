class Transfer < ApplicationRecord
  belongs_to :debit
  belongs_to :credit

  validate :debit_and_credit_value_must_be_the_same

  def debit_and_credit_value_must_be_the_same
    unless debit.present? && credit.present? && debit.value == credit.value
      errors.add(:base, "Debit and credit values must be the same")
    end
  end
end
