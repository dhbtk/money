require 'test_helper'

class RecurringDebitsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @recurring_debit = recurring_debits(:one)
  end

  test "should get index" do
    get recurring_debits_url
    assert_response :success
  end

  test "should get new" do
    get new_recurring_debit_url
    assert_response :success
  end

  test "should create recurring_debit" do
    assert_difference('RecurringDebit.count') do
      post recurring_debits_url, params: { recurring_debit: { account_id: @recurring_debit.account_id, day: @recurring_debit.day, months: @recurring_debit.months, name: @recurring_debit.name, value: @recurring_debit.value } }
    end

    assert_redirected_to recurring_debit_url(RecurringDebit.last)
  end

  test "should show recurring_debit" do
    get recurring_debit_url(@recurring_debit)
    assert_response :success
  end

  test "should get edit" do
    get edit_recurring_debit_url(@recurring_debit)
    assert_response :success
  end

  test "should update recurring_debit" do
    patch recurring_debit_url(@recurring_debit), params: { recurring_debit: { account_id: @recurring_debit.account_id, day: @recurring_debit.day, months: @recurring_debit.months, name: @recurring_debit.name, value: @recurring_debit.value } }
    assert_redirected_to recurring_debit_url(@recurring_debit)
  end

  test "should destroy recurring_debit" do
    assert_difference('RecurringDebit.count', -1) do
      delete recurring_debit_url(@recurring_debit)
    end

    assert_redirected_to recurring_debits_url
  end
end
