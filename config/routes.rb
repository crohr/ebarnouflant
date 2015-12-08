Rails.application.routes.draw do
  post 'ping', to: "hooks#ping"
  root to: "blog#index"
  get ':permalink', to: "blog#post"
end
