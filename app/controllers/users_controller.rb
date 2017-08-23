class UsersController < ApplicationController
	before_action :logged_in_user, only: [:edit, :update, :destroy]
	before_action :correct_user, only: [:edit, :update]

	def show
		@user = User.find(params[:id])
	end

  	def new
  		@user = User.new
  	end

  	def create
  		@user = User.new(user_params)
  		if @user.save
  			@user.send_activation_email
  			#This currently logs in the user. To not log in the
  			#user, go to 11.3 or thereabouts.
  			log_in @user
  			#Put the successful FLASH here
  			redirect_to @user
  		else
  			render 'new'
  		end
  	end

  	def edit
  		@user = User.find(params[:id])
  	end

  	def index
  		@users = User.all
  	end

  	def update
  		@user = User.find(params[:id])
  		if @user.update_attributes(user_params)
  			redirect_to @user
  		else
  			render 'edit'
  		end
  	end

  	def destroy
  		User.find(params[:id]).destroy
  		redirect_to users_url
  	end

    def cashTransfer
      @user = User.find(params[:id])

      _pf_id = params[:cashTrans][:portfolio].to_i
      _value = params[:cashTrans][:value].to_f
      _approved = false

      @user.portfolios.each do |portfolio|
        if _pf_id == portfolio.id
          _approved = true
        end
      end

      if (_approved)
        if (_value > 0 && @user.balanceAUD > _value)
          @user.update_attributes(balanceAUD: @user.balanceAUD - _value)
          Portfolio.find(_pf_id).update_attributes(cashAUD: Portfolio.find(_pf_id).cashAUD + _value)
        elsif (_value < 0 && Portfolio.find(_pf_id).cashAUD > -1*_value)
          Portfolio.find(_pf_id).update_attributes(cashAUD: Portfolio.find(_pf_id).cashAUD + _value)
          @user.update_attributes(balanceAUD: @user.balanceAUD - _value)
        else
          puts("Insufficient funds error")
        end

      else
        puts("User does not have permission to access this portfolio")

      end

      redirect_to @user

    end

  	private

  		def user_params
  			params.require(:user).permit(:name, :email, :password, 
  				:password_confirmation)
  		end

  		def logged_in_user
  			unless logged_in?
  				store_location
  				redirect_to login_url
  			end
  		end

  		#Confirms the correct user
  		def correct_user
  			@user= User.find(params[:id])
  			redirect_to(root_url) unless current_user?(@user)
  		end
end
