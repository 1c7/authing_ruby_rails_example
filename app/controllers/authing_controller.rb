require 'authing_ruby'

class AuthingController < ApplicationController

  # 一些例子
  def example
    # 初始化
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
    # res = authenticationClient.getAccessTokenByCode(code);

    # 返回示例
    res = {"status":200,"body":"{\"access_token\":\"eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6ImZ6S0U4TUlidkVkdl9Mb3N5a1dHTjdNTmpqbjlQMldvVmxtN0pIcFVZUFUifQ.eyJqdGkiOiJsMllkZ0RTZmhkcFhfM3ZGc2dHdlEiLCJzdWIiOiI2MDhiOWI1MjQxNGJkM2I3MWZhZDA0ZWYiLCJpYXQiOjE2MjAyODMxOTMsImV4cCI6MTYyMTQ5Mjc5Mywic2NvcGUiOiJvcGVuaWQgcHJvZmlsZSBwaG9uZSBlbWFpbCIsImlzcyI6Imh0dHBzOi8vcmFpbHMtZGVtby5hdXRoaW5nLmNuL29pZGMiLCJhdWQiOiI2MDgwMGI5MTUxZDA0MGFmOTAxNmQ2MGIifQ.N0s3N9n6RRbu5C1S8VOsIMkFLzv4ph6GOqPsWCdNOxa-Rj-wS3mRteoRs79lGaBtdHuu8pkXNXWARHx8hn6FJVfVZU-ydDZbHu3pY3SBmZtpkiMiFkCdujVLXaMrs5Q_ojMOto9WsABZva-z86fDFwUxhHOZzwMG6eIISAQFjjg2DouOCUxb5f4WuQwTw182EvUtsSrATlMHpYnwnv5TCIcmsxV-dEWC73fNNeQ19dr5JlwvGK2CZRXax5I9WsKlFMBF2c2e1RcSNClfKIL36TwOiHUfl3f74EPMHnBB1ncnbew7ygLGImlXeL27xfLdveXutNioxIKJLY3-y7UdNA\",\"expires_in\":1209600,\"id_token\":\"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI2MDhiOWI1MjQxNGJkM2I3MWZhZDA0ZWYiLCJiaXJ0aGRhdGUiOm51bGwsImZhbWlseV9uYW1lIjpudWxsLCJnZW5kZXIiOiJVIiwiZ2l2ZW5fbmFtZSI6bnVsbCwibG9jYWxlIjpudWxsLCJtaWRkbGVfbmFtZSI6bnVsbCwibmFtZSI6bnVsbCwibmlja25hbWUiOm51bGwsInBpY3R1cmUiOiJodHRwczovL2ZpbGVzLmF1dGhpbmcuY28vYXV0aGluZy1jb25zb2xlL2RlZmF1bHQtdXNlci1hdmF0YXIucG5nIiwicHJlZmVycmVkX3VzZXJuYW1lIjpudWxsLCJwcm9maWxlIjpudWxsLCJ1cGRhdGVkX2F0IjoiMjAyMS0wNC0zMFQwNTo1MzoyNi43ODJaIiwid2Vic2l0ZSI6bnVsbCwiem9uZWluZm8iOm51bGwsInBob25lX251bWJlciI6bnVsbCwicGhvbmVfbnVtYmVyX3ZlcmlmaWVkIjpmYWxzZSwiZW1haWwiOiIxQHFxLmNvbSIsImVtYWlsX3ZlcmlmaWVkIjpmYWxzZSwibm9uY2UiOiJJS1FrMF9qWXg4IiwiYXRfaGFzaCI6Ik5sUC1WeHpkRHlmb2hnOUFOR0FBemciLCJhdWQiOiI2MDgwMGI5MTUxZDA0MGFmOTAxNmQ2MGIiLCJleHAiOjE2MjE0OTI3OTMsImlhdCI6MTYyMDI4MzE5MywiaXNzIjoiaHR0cHM6Ly9yYWlscy1kZW1vLmF1dGhpbmcuY24vb2lkYyJ9._7nObGR0XMdCz-uWLiRvHP6OvbaPqwgP50DwaR_ViMo\",\"scope\":\"openid profile phone email\",\"token_type\":\"Bearer\"}","response_headers":{"server":"nginx/1.19.0","date":"Thu, 06 May 2021 06:39:53 GMT","content-type":"application/json; charset=utf-8","transfer-encoding":"chunked","connection":"keep-alive","vary":"Accept-Encoding, Origin","x-powered-by":"Express","pragma":"no-cache","cache-control":"no-cache, no-store","set-cookie":"authing_session=s%3AJXoCkNY7EVApWKnAEKQaZ_c6dXMg95Nb.E6%2FF24JFQ9YoykIVasa07p4sqeg3UdHmcrsP7idOtB4; Path=/; Expires=Thu, 20 May 2021 06:39:53 GMT; HttpOnly; Secure; SameSite=None","strict-transport-security":"max-age=15724800; includeSubDomains"}}
    # 演示怎么拿到 access_token
    body_string = res[:body]
    body = JSON.parse(body_string)
    access_token = body["access_token"]
    expires_in = body["expires_in"]
    id_token = body["id_token"]
    scope = body["scope"]
    token_type = body["token_type"]
    render json: access_token
  end

end
