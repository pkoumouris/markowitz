class PortfoliosController < ApplicationController
	
	def create
		if (params[:newPortfolio][:title].nil? || params[:newPortfolio][:description].nil? || params[:newPortfolio][:initial].nil? || params[:newPortfolio][:initial].to_f < 0.0)
			puts("Failed the create")
			redirect_to root_url
		else
			_title = params[:newPortfolio][:title]
			_description = params[:newPortfolio][:description]
			_initial = params[:newPortfolio][:initial].to_f
			current_user.update_attributes(balanceAUD: current_user.balanceAUD - _initial)
			current_user.portfolios.create(title: _title, description: _description, cashAUD: _initial)
			redirect_to current_user
		end
	end

	def show
		@portfolio = Portfolio.find(params[:id])
	end

	def add_execution

		#This is the thing that needs to be put into JSON

		@portfolio = Portfolio.find(params[:id])

		_secID = params[:execute][:sec].to_i
		puts("here1")
		puts("Trans type:"+params[:execute][:transType])
		#puts("Trans arg: "+params[:exeucte][:transArg])
		puts("Security ID: "+params[:execute][:sec])
		puts("Volume: "+params[:execute][:volume])

		if (params[:execute][:transType].to_i == 1)

			_scrip_volume = params[:execute][:volume].to_f

			if (@portfolio.cashAUD < (_scrip_volume * Security.find(_secID).price * 1.001) && _scrip_volume > 0)
				redirect_to root_url and return
			end

			@portfolio.executes.create( securityID: _secID, timeblock: 100, volume: _scrip_volume, status: 1)
			puts("here2")

		elsif (params[:execute][:transType].to_i == 2)

			_scrip_volume = (params[:execute][:volume].to_f / Security.find(_secID).price)

			if (_scrip_volume > 0)
				_scrip_volume /= 1.001
			end

			#if (@portfolio.cashAUD < (_scrip_volume * Security.find(_secID).price * 1.001) && _scrip_volume > 0)
				#redirect_to root_url and return
			#end

			@portfolio.executes.create( securityID: _secID, timeblock: 100, volume: _scrip_volume, status: 1)
			puts("here3")

		elsif (params[:execute][:transType].to_i == 3)

			_scrip_volume = params[:execute][:volume]

			current_user.update_attributes(balanceAUD: current_user.balanceAUD - _scrip_volume)

			@portfolio.update_attributes(cashAUD: @portfolio.cashAUD + _scrip_volume)
			puts("here4")

		elsif (params[:execute][:transType].to_i == 4)

			#Tether to another portfolio

		elsif (params[:execute][:transType].to_i == 5)

			#Image another portfolio

		end

		
		redirect_to @portfolio
	end

	private
		#def execute_params
		#	params.require(:execute).permit(:transType, :transArg, :sec, 
  		#		:volume)
		#end

		#Put algorithms etc. in here, or draw from Python

		def portfolio_params
			params.require(:portfolio).permit(:title, :description, :initial)
		end
end
