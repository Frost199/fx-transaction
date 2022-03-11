class CreateFxTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :fx_transactions do |t|
      t.integer :customer_id, null: false
      t.integer :transaction_id, null: false, unique: true
      t.decimal :input_amount, null: false, precision: 32, scale: 16
      t.string :input_currency, null: false
      t.decimal :output_amount, null: false, precision: 32, scale: 16
      t.string :output_currency, null: false
      t.timestamp :transaction_date, null: false

      t.timestamps
    end

    add_index :fx_transactions, :transaction_id
    add_index :fx_transactions, :customer_id
  end
end
