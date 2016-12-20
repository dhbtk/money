require 'test_helper'

class StatementsControllerTest < ActionDispatch::IntegrationTest
	test 'index should list statements with null names' do
		post new_user_session_path, params: {user: {email: 'user3@user.com', password: '12345678'}}
		get statements_path, params: {period: 'month'}
		assert_response :success
		assert_select '#statements-table > tbody > tr', 2
	end

	test 'index should not list statements with null names on search' do
		post new_user_session_path, params: {user: {email: 'user3@user.com', password: '12345678'}}
		get statements_path, params: {period: 'month', search: 'Named'}
		assert_response :success
		assert_select '#statements-table > tbody > tr', 1
	end
end
