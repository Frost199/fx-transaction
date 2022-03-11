require "test_helper"

class FxTransactionTest < ActiveSupport::TestCase
  test 'transaction should be valid' do
    fx_transaction = FxTransaction.new(
      customer_id: 1,
      input_amount: 9.99,
      transaction_id: 4,
      input_currency: 'ngn',
      output_amount: 9.99,
      output_currency: 'ngn',
      transaction_date: Time.zone.now
    )
    assert fx_transaction.valid?
  end

  test "transaction should not be valid if input_currency isn't a valid currency" do
    fx_transaction = FxTransaction.new(
      customer_id: 1,
      input_amount: 9.99,
      input_currency: 'xxx',
      output_amount: 9.99,
      output_currency: 'ngn',
      transaction_date: Time.zone.now
    )
    assert_not fx_transaction.valid?
  end

  test "transaction should not be valid if output_currency isn't a valid currency" do
    fx_transaction = FxTransaction.new(
      customer_id: 1,
      input_amount: 9.99,
      input_currency: 'ngn',
      output_amount: 9.99,
      output_currency: 'xxx',
      transaction_date: Time.zone.now
    )
    assert_not fx_transaction.valid?
  end

  test 'transaction with taken transaction_id should be invalid' do
    other_transaction = fx_transactions(:one)
    fx_transaction = FxTransaction.new(
      customer_id: 1,
      transaction_id: other_transaction.transaction_id,
      input_amount: 9.99,
      input_currency: 'ngn',
      output_amount: 9.99,
      output_currency: 'ngn',
      transaction_date: Time.zone.now
    )
    assert_not fx_transaction.valid?
  end

  test 'transaction should not be valid if the transaction date is in the future' do
    fx_transaction = FxTransaction.new(
      customer_id: 1,
      input_amount: 9.99,
      transaction_id: 2,
      input_currency: 'ngn',
      output_amount: 9.99,
      output_currency: 'ngn',
      transaction_date: Time.zone.now + 1.seconds
    )
    assert_not fx_transaction.valid?
  end
end
