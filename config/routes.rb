Rails.application.routes.draw do
  root to: "posts#index"
  resources :posts, only: [:index, :show]
  get 'feed', to: "feed#index", defaults: {format: :xml}
end
