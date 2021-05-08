Rails.application.routes.draw do
  root to: "home#index"

  # 一些简单使用例子
  get 'authing/example', to: "authing#example"

  get 'authing/method1', to: "authing#method1"
  
  get 'authing/callback', to: "authing#callback"

  get "user", to: "user#index"
  get "user/info", to: "user#info"
  get "user/update", to: "user#update"
  get 'user/logout', to: "user#logout"

  get "test", to: "test#index"
end
