class FxTransaction < ApplicationRecord
  validates :customer_id, presence: true
  validates :transaction_id, presence: true,
                             uniqueness: { message: 'transaction already exists.' },
                             numericality: { greater_than_or_equal_to: 0 }
  validates :input_amount, presence: true,
                           numericality: { greater_than_or_equal_to: 0, message: "input amount can't be less than 0" }
  validates :input_currency, presence: true
  validates :output_amount, presence: true,
                            numericality: { greater_than_or_equal_to: 0, message: "output amount can't be less than 0" }
  validates :output_currency, presence: true
  validates :transaction_date, presence: true
  validate :transaction_date_cannot_be_in_the_future
  validate :currency_is_of_supported_currency

  def transaction_date_cannot_be_in_the_future
    errors.add(:transaction_date, "can't be in the future") if transaction_date.present? && transaction_date.future?
  end

  def currency_is_of_supported_currency
    if input_currency.present? && Currency.find_by_code(input_currency).nil?
      errors.add(:input_currency, 'currency is not supported')
    end
    if output_currency.present? && Currency.find_by_code(output_currency).nil?
      errors.add(:output_currency, 'currency is not supported')
    end
  end

  def to_param
    transaction_id&.to_s
  end
end
