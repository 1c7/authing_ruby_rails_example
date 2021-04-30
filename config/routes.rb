Rails.application.routes.draw do
  get 'authing/method1', to: "authing#method1"
  get 'authing/callback', to: "authing#callback"
end
