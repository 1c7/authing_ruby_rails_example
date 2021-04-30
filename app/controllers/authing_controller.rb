require 'authing_ruby'

class AuthingController < ApplicationController

  # 一些例子
  def example
    # options = {
    #   appId: "60800b9151d040af9016d60b",
    #   appHost: "https://rails-demo.authing.cn",
    #   userPoolId: "60800b8ee5b66b23128b4980", 
    # }
    # authenticationClient = AuthingRuby::AuthenticationClient.new(options)

    # 邮箱密码注册
    # email = "user#{rand(0...9999)}@qq.com"
    # password = "12345678" # 密码
    # resp = authenticationClient.registerByEmail(email, password)
    # render json: resp # 返回注册成功的用户信息

    # 用户名密码注册
    # username = "user#{rand(0...9999)}" # 用户名
    # password = "12345678" # 密码
    # resp = authenticationClient.registerByUsername(username, password)
    # render json: resp # 返回注册成功的用户信息
    
    # 发手机验证码
    # phone = "13556136684"
    # resp = authenticationClient.sendSmsCode(phone)
    # render json: resp
  end

  # 托管登录页认证
  # https://docs.authing.cn/v2/guides/authentication/#%E6%89%98%E7%AE%A1%E7%99%BB%E5%BD%95%E9%A1%B5%E8%AE%A4%E8%AF%81
  def method1
    # 认证地址
    appHost = "https://rails-demo.authing.cn/"
    redirect_to appHost
  end

  # 回调地址
  def callback
    # render json: params
    # {"code":"Lfu675cmNzgTEePe_SMfsSFp32kQepVKF83JUTqO09-","state":"g60NuMx0H","controller":"authing","action":"callback"}

    code = params[:code]
    render json: code

    # options = {
    #   appId: "60800b9151d040af9016d60b",
    #   appHost: "https://rails-demo.authing.cn",
    #   userPoolId: "60800b8ee5b66b23128b4980", 
    # }
    # authenticationClient = AuthingRuby::AuthenticationClient.new(options)

    # TODO 用  ENV 提供 secret
    const authenticationClient = new AuthenticationClient({
      appId: '应用 ID',
      secret: '应用密钥',
      appHost: 'https://{YOUR_DOMAIN}.authing.cn',
      redirectUri: '业务回调地址',
    });
    let res = await authenticationClient.getAccessTokenByCode('授权码 code');
    let res2 = await authenticationClient.getAccessTokenByCode('授权码 code', {
      codeVerifier: 'code_challenge 原始值'
    });

    # TODO  用 code 换取 token
    # 最后拿到用户信息
  end

end
