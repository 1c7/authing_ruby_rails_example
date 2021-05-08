Rails.application.routes.draw do
  # 方式1：传统的 Cookie Session
  root to: "home#index"

  # 一些简单使用例子
  get 'authing/example', to: "authing#example"

  # 填在 Authing 里的回调地址就是这个
  get 'authing/callback', to: "authing#callback"

  # 获得用户信息
  get "user", to: "user#index"

  # 更新用户信息
  get "user/update", to: "user#update"

  # 退出登录
  get 'user/logout', to: "user#logout"

  get "test", to: "test#index"
end
