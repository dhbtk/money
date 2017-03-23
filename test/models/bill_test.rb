# == Schema Information
#
# Table name: bills
#
#  id                 :integer          not null, primary key
#  billing_account_id :integer
#  name               :string
#  value              :decimal(, )
#  expiration         :datetime
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  credit_id          :integer
#  barcode            :string
#  attachment         :string
#
# Indexes
#
#  index_bills_on_billing_account_id  (billing_account_id)
#  index_bills_on_credit_id           (credit_id)
#

require 'test_helper'

class BillTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
