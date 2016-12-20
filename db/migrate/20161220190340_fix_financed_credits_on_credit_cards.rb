class FixFinancedCreditsOnCreditCards < ActiveRecord::Migration[5.0]
  def change
  	  Credit.where.not(recurring_credit_id: nil).each do |credit|
  	  	  credit.update! date: credit.account.financed_credit_date(credit.date)
  	  end
  end
end
