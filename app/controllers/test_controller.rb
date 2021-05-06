class TestController < ApplicationController
  def cookie
    cookies[:haircolor] = "blonde2"
    session[:user_id] = 3
    # render json: cookies[:haircolor]
    # render json: session
    render json: session[:user_id]
  end
end
