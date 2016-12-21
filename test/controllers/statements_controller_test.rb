require 'test_helper'

class StatementsControllerTest < ActionDispatch::IntegrationTest
	test 'index should list statements with null names' do
		post new_user_session_path, params: {user: {email: 'user3@user.com', password: '12345678'}}
		get statements_path
		assert_response :success
		assert_select '#statements-table > tbody > tr', 2
	end

	test 'index should not list statements with null names on search' do
		post new_user_session_path, params: {user: {email: 'user3@user.com', password: '12345678'}}
		get statements_path, params: {search: 'Named'}
		assert_response :success
		assert_select '#statements-table > tbody > tr', 1
	end

	test 'index search should filter by type optionally' do
		post new_user_session_path, params: {user: {email: 'user4@user.com', password: '12345678'}}
		get statements_path
		assert_response :success
		assert_select '#statements-table > tbody > tr', 5
		assert_select 'select#type', 1
		assert_select 'select#type > option', 6
		get statements_path, params: {type: 'debit'}
		assert_select '#statements-table > tbody > tr', 1
		assert_select '#statements-table > tbody > tr > td:nth-child(3) > span.debit', accounts(:account4).name
		get statements_path, params: {type: 'credit'}
		assert_select '#statements-table > tbody > tr', 1
		assert_select '#statements-table > tbody > tr > td:nth-child(3) > span.credit', 'Despesas'
		get statements_path, params: {type: 'bill'}
		assert_select '#statements-table > tbody > tr', 1
		assert_select '#statements-table > tbody > tr > td:nth-child(3) > span.credit', billing_accounts(:billing_account1).name
		get statements_path, params: {type: 'recurring_credit'}
		assert_select '#statements-table > tbody > tr', 1
		assert_select '#statements-table > tbody > tr > td:nth-child(3) > span.credit', 'Despesas'
		get statements_path, params: {type: 'transfer'}
		assert_select '#statements-table > tbody > tr', 1
		assert_select '#statements-table > tbody > tr > td:nth-child(3) > span.transfer:first-child', accounts(:account4).name
		assert_select '#statements-table > tbody > tr > td:nth-child(3) > span.transfer:last-child', accounts(:wallet).name
	end
end
