# 可以在 config/initializers 里这样初始化
# 用的时候直接写 AuthingRuby.auth_client
# 就不用每次都调用 AuthingRuby::AuthenticationClient.new(options)

module AuthingRuby
	class << self
		def auth_client
			options = {
				appId: ENV['AUTHING_APP_ID'],
				appHost: ENV['AUTHING_APP_HOST'],
				userPoolId: ENV['AUTHING_USERPOOL_ID'], 
			}
			client = AuthingRuby::AuthenticationClient.new(options)
			return client
		end
	end
end