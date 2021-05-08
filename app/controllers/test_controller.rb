class TestController < ApplicationController
	def index
		render plain: AuthingRuby.auth_client
	end
end
