require 'test_helper'

class StatementTest < ActiveSupport::TestCase
	test 'search scope should not return statements with no name' do
	  	assert_equal 0, users(:user3).statements.search('Named').to_a.select{|s| s.name.nil?}.count
	end
end
