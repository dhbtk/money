require 'test_helper'

class RecurringCreditTest < ActiveSupport::TestCase
	test 'financed expenses on a credit card should be on the closing date except for the first' do
		credit = Credit.new(value: 50, account: accounts(:credit_card), date: '2016-12-20', months: 5, name: 'Teste de Parcelamento')
		assert credit.save
		recurring_credit = credit.recurring_credit
		assert recurring_credit
		first = true
		recurring_credit.credits.to_a.each do |credit|
			if first
				assert_equal recurring_credit.start_date, credit.date
				first = false
			else
				assert_equal accounts(:credit_card).closing, credit.date.day
			end
		end
	end
end
