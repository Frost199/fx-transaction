require 'test_helper'

class Api::V1::FxTransactionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @fx_transaction = fx_transactions(:one)
  end

  test 'should show fx transactions' do
    get api_v1_fx_transactions_url, as: :json
    assert_response :success

    json_response = JSON.parse(response.body, symbolize_names: true)
    assert_not_nil json_response.dig(:links, :first)
    assert_not_nil json_response.dig(:links, :last)
    assert_not_nil json_response.dig(:links, :prev)
    assert_not_nil json_response.dig(:links, :next)
  end

  test 'should show fx transaction' do
    get api_v1_fx_transaction_url(@fx_transaction), as: :json
    assert_response :success
    # Test to ensure response contains the correct transaction data
    json_response = JSON.parse(response.body)
    assert_equal @fx_transaction.customer_id, json_response['data']['attributes']['customer_id']
    assert_equal @fx_transaction.transaction_id, json_response['data']['attributes']['transaction_id']
    assert_equal @fx_transaction.input_amount.to_s, json_response['data']['attributes']['input_amount']
    assert_equal @fx_transaction.input_currency, json_response['data']['attributes']['input_currency']
    assert_equal @fx_transaction.output_amount.to_s, json_response['data']['attributes']['output_amount']
    assert_equal @fx_transaction.output_currency, json_response['data']['attributes']['output_currency']
    assert_equal @fx_transaction.transaction_date, json_response['data']['attributes']['transaction_date']
  end

  test 'should create fx transaction' do
    assert_difference('FxTransaction.count') do
      post api_v1_fx_transactions_url, params: {
        fx_transaction: {
          customer_id: 1,
          transaction_id: 4,
          input_amount: 10.23,
          input_currency: 'ngn',
          output_amount: 12.02,
          output_currency: 'ngn',
          transaction_date: Time.zone.now
        }
      }, as: :json
    end
    assert_response :created
  end

  test 'should update fx transaction' do
    # other_transaction = @fx_transaction
    fx_transaction = create_transaction
    assert_changes('fx_transaction') do
      put api_v1_fx_transaction_url(fx_transaction), params: {
        fx_transaction: {
          customer_id: 1,
          transaction_id: 4,
          input_amount: 100.222,
          input_currency: 'cad',
          output_amount: 12.02,
          output_currency: 'ngn',
          transaction_date: Time.zone.now
        }
      }, as: :json
    end
    # new_transaction = fx_transactions(:one)
    # assert_not_equal other_transaction.input_currency, new_transaction.input_currency
  end

  def create_transaction
    FxTransaction.create(
      customer_id: 1,
      input_amount: 9.99,
      transaction_id: 4,
      input_currency: 'ngn',
      output_amount: 9.99,
      output_currency: 'ngn',
      transaction_date: Time.zone.now
    )
  end
end
