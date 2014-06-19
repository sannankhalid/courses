class UsersController < ApplicationController
	skip_before_filter :require_login
	def new
	  @user = User.new
	end

	def home
		@user = User.new
	end

	def welcome
	end

	def create
		
		@user = User.new(params[:user])
		@user.user_type = "end_user"
		if @user.save
		    redirect_to root_url, :notice => "Signed up!"
  		else
    		render "new"
  		end
	end
end
