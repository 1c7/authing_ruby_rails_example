Rails.application.routes.draw do

  get 'authing/method1', to: "authing#method1"
  get 'authing/callback', to: "authing#callback"
  get "test/cookie", to: "test#cookie"

  get "user", to: "user#index"
  get "user/info", to: "user#info"
  get "user/update", to: "user#update"
end
