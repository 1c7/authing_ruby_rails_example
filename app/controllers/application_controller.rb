class ApplicationController < ActionController::Base
	helper_method :user_signed_in?, :current_user # 写了 helper_method 之后 view 里才可以调用这2个方法

	# 判断是否登录了, 方法名模仿的是 devise
	def user_signed_in?
		return session[:user_id] != nil
	end

	# 返回当前用户
	def current_user
		return nil if user_signed_in?() == false
		user_id = session[:user_id]
		user = User.find(user_id)
		return user
	end

	# 用于 before_action，如果用户没登录，返回登录页
	def authenticate_user
		if user_signed_in? == false
			redirect_to "/authing/method1"
		end
	end

end
