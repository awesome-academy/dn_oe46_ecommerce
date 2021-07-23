Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"

    get "/sort", to: "static_pages#sort"
    resources :users
    resources :categories do
      resources :products, only: [:index]
    end
    resources :products, only: [:show]
    resources :sessions, only: [:new, :create, :destroy]
  end
end
