require 'test_helper'

class RecurringCreditTest < ActiveSupport::TestCase
  test 'financed expenses on a credit card should be on the closing date except for the first' do
    credit = Credit.new(value: 50, account: accounts(:credit_card), date: '2015-12-20', months: 5, name: 'Teste de Parcelamento')
    assert credit.save
    recurring_credit = credit.recurring_credit
    assert recurring_credit
    first = true
    recurring_credit.credits.to_a.each do |c|
      if first
        assert_equal recurring_credit.start_date, c.date
        first = false
      else
        assert_equal accounts(:credit_card).closing, c.date.day
      end
    end
    # verifying that it holds for the update
    assert recurring_credit.update(start_date: Date.new(2015, 12, 21))
    recurring_credit.reload
    first = true
    Credit.where(recurring_credit_id: recurring_credit.id).order(:date).each do |c|
      if first
        assert_equal recurring_credit.start_date, c.date
        first = false
      else
        assert_equal accounts(:credit_card).closing, c.date.day
      end
    end
  end

  test 'uneven installment values should be accounted for in the first installment' do
    # total is 50.56. First installment should be 10.12, others should be 10.11
    first_installment = Credit.new(
        value: BigDecimal.new('50.56'), months: 5, account: accounts(:credit_card), date: '2013-02-05', name: 'Teste de Valor de Parcela')
    assert first_installment.save
    assert_equal BigDecimal.new('10.12'), first_installment.value
    first_installment.recurring_credit.credits.to_a[1..-1].each do |credit|
      assert_equal BigDecimal.new('10.11'), credit.value
    end
  end
end
