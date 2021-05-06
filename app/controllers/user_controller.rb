class UserController < ApplicationController
	# 本 Controller 里所有 action 都需要登录后
	before_action :authenticate_user

	# 去 Authing 拿用户信息
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

	def info
	end

	# 更新用户信息
	def update
		
	end

end
