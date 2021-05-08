class UserController < ApplicationController
	# 本 Controller 里所有 action 都需要登录后
	before_action :authenticate_user

	# 去 Authing 拿用户信息
	# 方式是通过 idToken 来做
	def index
		user = current_user()
		id_token = user.authing_id_token

		options = {
			appId: ENV["AUTHING_APP_ID"],
			appHost: ENV["AUTHING_APP_HOST"],
			token: id_token,
		}

		authenticationClient = AuthingRuby::AuthenticationClient.new(options)
		authing_response = authenticationClient.getCurrentUser()
		render json: authing_response
	end

	# 初始化 AuthenticationClient
	def get_auth_client()
		user = current_user()
		id_token = user.authing_id_token

		options = {
			appId: ENV["AUTHING_APP_ID"],
			appHost: ENV["AUTHING_APP_HOST"],
			token: id_token,
		}

		authenticationClient = AuthingRuby::AuthenticationClient.new(options)
		return authenticationClient
	end

	# 更新用户信息
	def update
    authenticationClient = get_auth_client()
		res = authenticationClient.updateProfile({
			nickname: "nick"
		})
		render json: res
	end

	# 退出登录
	def logout
		# 去 Authing 那边退出登录
    authenticationClient = get_auth_client()
		authenticationClient.logout

		# 清空 session
		reset_session

		# 回到首页
		redirect_to root_path
	end

end
