Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"

    resources :users
    resources :sessions, only: [:new, :create, :destroy]
  end
end
