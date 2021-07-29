Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"

    get "/sort", to: "static_pages#sort"
    resources :carts, only: [:index] do
      collection do
        post "add_to_cart/:id", to: "carts#add_to_cart", as: "add_to"
      end
    end
    resources :users
    resources :categories do
      resources :products, only: [:index]
    end
    resources :products, only: [:show]
    resources :sessions, only: [:new, :create, :destroy]
  end
end
