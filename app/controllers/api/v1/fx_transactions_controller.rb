# frozen_string_literal: true

module Api
  module V1
    class FxTransactionsController < ApplicationController
      before_action :fx_transaction, only: [:show, :update]
      include Paginable

      def index
        @fx_transactions = FxTransaction.page(params[:page])
                                        .per(params[:per_page])
        options = get_links_serializer_options('api_v1_fx_transactions_path', @fx_transactions)
        render json: FxTransactionSerializer.new(@fx_transactions, options).serializable_hash, status: :ok
      end

      def create
        @fx_transaction = FxTransaction.new(fx_transaction_params)
        @fx_transaction.save!
        render json: FxTransactionSerializer.new(@fx_transaction).serializable_hash, status: :created
      rescue ActiveRecord::RecordInvalid
        raise CustomErrors::Invalid.new(errors: @fx_transaction.errors.to_hash)
      end

      def show
        raise CustomErrors::NotFound.new(url_path: api_v1_fx_transaction_path) if @fx_transaction.nil?

        render json: FxTransactionSerializer.new(@fx_transaction).serializable_hash, status: :ok
      end

      def update
        @fx_transaction.update!(fx_transaction_params)
        render json: FxTransactionSerializer.new(@fx_transaction).serializable_hash, status: :ok
      rescue ActiveRecord::RecordInvalid
        raise CustomErrors::Invalid.new(errors: @fx_transaction.errors.to_hash)
      end

      private

      def fx_transaction
        @fx_transaction = FxTransaction.find_by(transaction_id: params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def fx_transaction_params
        params.require(:fx_transaction).permit(
          :customer_id,
          :transaction_id,
          :input_amount,
          :input_currency,
          :output_amount,
          :output_currency,
          :transaction_date
        )
      end
    end
  end
end
