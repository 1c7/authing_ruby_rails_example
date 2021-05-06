class UserController < ApplicationController
	def info
		render json: session
	end
end
