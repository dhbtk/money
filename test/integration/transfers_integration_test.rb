require 'test_helper'

class TransfersIntegrationTest < ActionDispatch::IntegrationTest
  include ActionView::Helpers

  test 'log in and make a transfer' do
    # logging out just to make sure
    delete destroy_user_session_path
    @user = users(:user2)
    get '/'
    assert_redirected_to new_user_session_path
    follow_redirect!
    post user_session_path, params: { user: { email: 'user2@user.com', password: '12345678' } }
    assert_redirected_to root_path
    get statements_path, params: { period: 'month' }
    assert_response :success
    assert_select '#statements-table > tbody > tr', 2

    get new_transfer_path
    post transfers_path,
        params: { transfer: { value: 50.00, source_account_id: accounts(:account2).id, destination_account_id: accounts(:credit_card).id, description: 'Transferência de Teste' } }
    assert_redirected_to statements_path

    get statements_path, params: { period: 'month' }
    assert_select '#statements-table > tbody > tr', 3
    assert_select '#statements-table > tbody > tr:first-child > td:nth-child(3) > span.transfer', 2
    assert_select '#statements-table > tbody > tr:first-child > td:nth-child(5)', 'Transferência de Teste'

    assert_select 'div.account-totals > ul > li.account:first-child > .account-total > span:first-child', number_to_currency(0)
    assert_select 'div.account-totals > ul > li.account:first-child > .account-total > span:last-child', number_to_currency(5000)

    assert_select 'div.account-totals > ul > li.account:last-child > .account-total > span:last-child', number_to_currency(950)
  end
end
