class FxTransactionSerializer
  include JSONAPI::Serializer
  set_type :fx_transaction
  attributes :customer_id, :transaction_id, :input_amount, :input_currency, :output_amount, :output_currency, :transaction_date
  cache_options store: Rails.cache, namespace: 'jsonapi-serializer', expires_in: 1.hour
end
