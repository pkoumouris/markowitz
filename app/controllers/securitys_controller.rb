class SecuritysController < ApplicationController

	def show
		@security = Security.find(params[:id])
	end

	def index
		
	end

	def add_execution
		@security = Security.find(params[:id])
		_pf_id = params[:buySell][:portfolio].to_i
		_value = params[:buySell][:value].to_f

		_approved = false

		current_user.portfolios.each do |portfolio|
			if (_pf_id == portfolio.id)
				_approved = true
				puts("X1")
			end
		end

		_has_asset = false

		current_user.portfolios.each do |portfolio|
			portfolio.assets.each do |asset|
				if (asset.sec == @security.id)
					_has_asset = true
					puts("X2")
				end
			end
		end
		#ISSUES! :O
		if (_approved)
			Portfolio.find(_pf_id).executes.create(securityID: @security.id, timeblock: 100, volume: (_value/@security.price)/1.001, status: 1)
		end
		redirect_to root_url
	end

end
