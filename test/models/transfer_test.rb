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

require 'test_helper'

class TransferTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
