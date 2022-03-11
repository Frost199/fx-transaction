Rails.application.routes.draw do
  # Api definition
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :fx_transactions, only: %i[show create index], path: 'transactions'
    end
  end
end
