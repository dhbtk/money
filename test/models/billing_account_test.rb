# == Schema Information
#
# Table name: billing_accounts
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  name       :string
#  enabled    :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_billing_accounts_on_user_id  (user_id)
#

require 'test_helper'

class BillingAccountTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
