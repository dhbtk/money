# == Schema Information
#
# Table name: accounts
#
#  id         :integer          not null, primary key
#  name       :string
#  expiration :integer
#  type       :string
#  closing    :integer
#  interest   :decimal(8, 4)
#  fine       :decimal(8, 2)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#  limit      :decimal(8, 2)
#  icon       :string
#
# Indexes
#
#  index_accounts_on_user_id  (user_id)
#

require 'test_helper'

class AccountTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
