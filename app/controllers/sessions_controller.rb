class SessionsController < ApplicationController
	skip_before_filter :require_login

	def new
	end






	def create
		user = User.authenticate(params[:email], params[:password])
		if user
			session[:user_id] = user.id
			@answer = Answer.where(:user_id => user.id)
           if @answer.present? 
           redirect_to question_path(1), :notice => "Logged in!"
           else
           redirect_to requestionare_path, :notice => "Logged in!"
           
           end
		else
		    flash.now.alert = "Invalid email or password"
		    render "new"
		end
	end




	def destroy
	  session[:user_id] = nil
	  redirect_to root_url, :alert => "Logged out!"
	end
end
