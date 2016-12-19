require 'test_helper'

class StatementsIntegrationTest < ActionDispatch::IntegrationTest
  include ActionView::Helpers

  test 'should get to login page' do
    get '/'
    assert_redirected_to new_user_session_path
  end

  test 'should log in and see statements' do
    get '/'
    assert_redirected_to new_user_session_path
    follow_redirect!
    post user_session_path,
        params: { user: { email: 'user@user.com', password: '12345678' } }
    assert_redirected_to root_path
    follow_redirect!
    assert_select 'div.avatar-dropdown > span', 'user@user.com'

    get statements_path, params: { period: 'month' }
    assert_select '#statements-table > tbody > tr', 2


    # verifying balance
    get accounts_path
    assert_select 'div.account', 1
    assert_select 'div.account > .details > div > span', number_to_currency(120)

    get new_credit_path
    assert_response :success
    post credits_path, params: { credit: { name: 'Gasto', account_id: accounts(:account1).id, value: 20 }}
    assert_redirected_to statements_path
    get statements_path, params: { period: 'month' }
    assert_select '#statements-table > tbody > tr', 3
    # verifying balance
    get accounts_path
    assert_select 'div.account', 1
    assert_select 'div.account > .details > div > span', number_to_currency(100)

    delete credit_path(credits(:credit1))
    assert_redirected_to statements_path
    get statements_path, params: { period: 'month' }
    assert_select '#statements-table > tbody > tr', 2
    get accounts_path
    assert_select 'div.account', 1
    assert_select 'div.account > .details > div > span', number_to_currency(103.45)

    get new_debit_path
    assert_response :success
    post debits_path, params: { debit: { name: 'Receita', account_id: accounts(:account1).id, value: 1.55 }}
    assert_redirected_to statements_path
    get statements_path, params: { period: 'month' }
    assert_select '#statements-table > tbody > tr', 3
    assert_select 'li.account > .account-total > span', number_to_currency(105)
  end
end
