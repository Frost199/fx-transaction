Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Api definition
  namespace :api, defaults: { format: :json } do
    namespace :v1 do

    end
  end
end