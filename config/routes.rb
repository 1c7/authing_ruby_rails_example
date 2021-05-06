Rails.application.routes.draw do
  get 'test/cookie'
  get 'authing/method1', to: "authing#method1"
  get 'authing/callback', to: "authing#callback"
  get "test/cookie", to: "test#cookie"
  get "user/info", to: "user#info"
end
