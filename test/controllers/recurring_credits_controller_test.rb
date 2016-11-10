require 'test_helper'

class RecurringCreditsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @recurring_credit = recurring_credits(:one)
  end

  test "should get index" do
    get recurring_credits_url
    assert_response :success
  end

  test "should get new" do
    get new_recurring_credit_url
    assert_response :success
  end

  test "should create recurring_credit" do
    assert_difference('RecurringCredit.count') do
      post recurring_credits_url, params: { recurring_credit: { account_id: @recurring_credit.account_id, day: @recurring_credit.day, expiration: @recurring_credit.expiration, fine: @recurring_credit.fine, interest: @recurring_credit.interest, months: @recurring_credit.months, name: @recurring_credit.name, value: @recurring_credit.value } }
    end

    assert_redirected_to recurring_credit_url(RecurringCredit.last)
  end

  test "should show recurring_credit" do
    get recurring_credit_url(@recurring_credit)
    assert_response :success
  end

  test "should get edit" do
    get edit_recurring_credit_url(@recurring_credit)
    assert_response :success
  end

  test "should update recurring_credit" do
    patch recurring_credit_url(@recurring_credit), params: { recurring_credit: { account_id: @recurring_credit.account_id, day: @recurring_credit.day, expiration: @recurring_credit.expiration, fine: @recurring_credit.fine, interest: @recurring_credit.interest, months: @recurring_credit.months, name: @recurring_credit.name, value: @recurring_credit.value } }
    assert_redirected_to recurring_credit_url(@recurring_credit)
  end

  test "should destroy recurring_credit" do
    assert_difference('RecurringCredit.count', -1) do
      delete recurring_credit_url(@recurring_credit)
    end

    assert_redirected_to recurring_credits_url
  end
end
