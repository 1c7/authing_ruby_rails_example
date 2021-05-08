class TestController < ApplicationController
	def index
		# 输出当前的 Session Storage (session 的存储方式)
		render plain: Rails.application.config.session_store # ActionDispatch::Session::CookieStore
		
		# 运行我们在 initializers 里写的代码
		# render plain: AuthingRuby.auth_client
	end
end
