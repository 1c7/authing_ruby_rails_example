require 'authing_ruby'

class AuthingController < ApplicationController

  # 首先是一些简单例子，取消注释并访问 http://localhost:3000/authing/example
  def example
    # 初始化
    # options = {
    #   appId: ENV['AUTHING_APP_ID'],
    #   appHost: ENV['AUTHING_APP_HOST'],
    #   userPoolId: ENV['AUTHING_USERPOOL_ID'], 
    # }
    # authenticationClient = AuthingRuby::AuthenticationClient.new(options)

    # 邮箱+密码注册
    # email = "user#{rand(0...9999)}@qq.com"
    # password = "12345678" # 密码
    # resp = authenticationClient.registerByEmail(email, password)
    # render json: resp # 返回注册成功的用户信息

    # 用户名+密码注册
    # username = "user#{rand(0...9999)}" # 用户名
    # password = "12345678" # 密码
    # resp = authenticationClient.registerByUsername(username, password)
    # render json: resp # 返回注册成功的用户信息
    
    # 发送短信验证码
    # phone = "13556136684"
    # resp = authenticationClient.sendSmsCode(phone)
    # render json: resp

    render plain: '例子'
  end

  # 托管登录页认证
  # https://docs.authing.cn/v2/guides/authentication/#%E6%89%98%E7%AE%A1%E7%99%BB%E5%BD%95%E9%A1%B5%E8%AE%A4%E8%AF%81
  # http://localhost:3000/authing/method1
  def method1
    # 如果没登录
    if session[:user_id] == nil
      # 认证地址
      appHost = "https://rails-demo.authing.cn/"
      redirect_to appHost
      return
    end

    user = User.find(session[:user_id])
    render json: user
  end

  # 回调地址
  def callback
    # params 长这样
    # render json: params
    # {"code":"Lfu675cmNzgTEePe_SMfsSFp32kQepVKF83JUTqO09-","state":"g60NuMx0H","controller":"authing","action":"callback"}

    # 先拿到 code
    code = params[:code]

    # 初始化
    options = {
      appId: ENV['AUTHING_APP_ID'],
      secret: ENV['AUTHING_SECRET'],
      appHost: ENV['AUTHING_APP_HOST'],
      userPoolId: ENV['AUTHING_USERPOOL_ID'], 
    }
    authenticationClient = AuthingRuby::AuthenticationClient.new(options)

    # 用 code 换取 token
    # res = authenticationClient.getAccessTokenByCode(code)
    # 返回示例
    res = {
      "access_token":"eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6ImZ6S0U4TUlidkVkdl9Mb3N5a1dHTjdNTmpqbjlQMldvVmxtN0pIcFVZUFUifQ.eyJqdGkiOiJnYmVIcDYtM1FBYmIzNWpmNDlTWVMiLCJzdWIiOiI2MDhiOWI1MjQxNGJkM2I3MWZhZDA0ZWYiLCJpYXQiOjE2MjAyODY2NDAsImV4cCI6MTYyMTQ5NjI0MCwic2NvcGUiOiJvcGVuaWQgZW1haWwgcHJvZmlsZSBwaG9uZSIsImlzcyI6Imh0dHBzOi8vcmFpbHMtZGVtby5hdXRoaW5nLmNuL29pZGMiLCJhdWQiOiI2MDgwMGI5MTUxZDA0MGFmOTAxNmQ2MGIifQ.qxPlpewKtxeTDZ13Z0FUFpfJ8JrX3CKXnYj9gTaOt9IZmzxpkJp4GyVbfdz6YVvhcgPb5Hr76w6Cq-PMWAQ-_ajy9CQUFUvvuQVvDMmoW0HqwYTdpQKg8vAeU8NSfivdMuJqyDt5dytGTU0OxmN6Q1BHXx3wS0DlVVqyB1PDTYJjXW2LDzMRiLWS8QDXWMiEZ3cMSZzzAyDh98adi_Vd0g5hLbKOlICi9aQ-5Q9ze0GNO-p50eoy9cQzS0EuYNJ7PqGoGgfkUgxKwbKlbYYqCVbGs1Gc_D-85WA49uXfq4KEM3aJiwpvcMhHLq3vY_TU3ENoobYUTtd-N3GfnQGZdw",
      "expires_in":1209600,
      "id_token":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI2MDhiOWI1MjQxNGJkM2I3MWZhZDA0ZWYiLCJlbWFpbCI6IjFAcXEuY29tIiwiZW1haWxfdmVyaWZpZWQiOmZhbHNlLCJiaXJ0aGRhdGUiOm51bGwsImZhbWlseV9uYW1lIjpudWxsLCJnZW5kZXIiOiJVIiwiZ2l2ZW5fbmFtZSI6bnVsbCwibG9jYWxlIjpudWxsLCJtaWRkbGVfbmFtZSI6bnVsbCwibmFtZSI6bnVsbCwibmlja25hbWUiOm51bGwsInBpY3R1cmUiOiJodHRwczovL2ZpbGVzLmF1dGhpbmcuY28vYXV0aGluZy1jb25zb2xlL2RlZmF1bHQtdXNlci1hdmF0YXIucG5nIiwicHJlZmVycmVkX3VzZXJuYW1lIjpudWxsLCJwcm9maWxlIjpudWxsLCJ1cGRhdGVkX2F0IjoiMjAyMS0wNC0zMFQwNTo1MzoyNi43ODJaIiwid2Vic2l0ZSI6bnVsbCwiem9uZWluZm8iOm51bGwsInBob25lX251bWJlciI6bnVsbCwicGhvbmVfbnVtYmVyX3ZlcmlmaWVkIjpmYWxzZSwibm9uY2UiOiJpcTl4eHZmSVVpIiwiYXRfaGFzaCI6IjRRdjJZUjVScUE2UDNjcGJ4VDV0TGciLCJhdWQiOiI2MDgwMGI5MTUxZDA0MGFmOTAxNmQ2MGIiLCJleHAiOjE2MjE0OTYyNDEsImlhdCI6MTYyMDI4NjY0MSwiaXNzIjoiaHR0cHM6Ly9yYWlscy1kZW1vLmF1dGhpbmcuY24vb2lkYyJ9.WmG8z6TaQou23Czc69sldtAHg1AubgclFrrnz0fARP8",
      "scope":"openid email profile phone",
      "token_type":"Bearer"
    }

    # 演示拿 access_token
    access_token = res[:access_token]
    id_token = res[:id_token]

    # 这种叫授权码模式
    # 文档请看 https://docs.authing.cn/v2/guides/federation/oidc.html#%E6%8E%88%E6%9D%83%E7%A0%81%E6%A8%A1%E5%BC%8F

    # 用 access token 换取用户信息
    userInfo = authenticationClient.getUserInfoByAccessToken(access_token)
    userInfoJSON = JSON.parse(userInfo)
    # render json: userInfoJSON["sub"]
    # return
    # 返回例子: 
    # userInfoExample = {
    #   "sub":"608b9b52414bd3b71fad04ef",
    #   "email":"1@qq.com",
    #   "email_verified":false,
    #   "birthdate":null,
    #   "family_name":null,
    #   "gender":"U",
    #   "given_name":null,
    #   "locale":null,
    #   "middle_name":null,
    #   "name":null,
    #   "nickname":null,
    #   "picture":"https://files.authing.co/authing-console/default-user-avatar.png",
    #   "preferred_username":null,
    #   "profile":null,
    #   "updated_at":"2021-04-30T05:53:26.782Z",
    #   "website":null,
    #   "zoneinfo":null,
    #   "phone_number":null,
    #   "phone_number_verified":false
    # }

    # 根据 Authiing 用户 ID 创建用户纪录
    user_id = userInfoJSON["sub"]
    user = User.find_or_create_by(authing_user_id: user_id)
    user.authing_id_token = res[:id_token]
    user.authing_access_token = res[:access_token]
    user.save

    session[:user_id] = user.id # 用数据库 id 做标识

    # 输出用户信息
    # render json: user

    redirect_to root_path
  end

  # 验证 token
  def verify_token
  end

  # 已登录的用户，获取自己的用户信息
  def user_info

  end

end
