class ExecutesController < ApplicationController

	def new
		#_secID = params[:execute][:sec]
		#if (params[:execute][:transType] == 1)
			#_scrip_volume = params[:execute][:volume]
		#elsif (params[:execute][:transType] == 2)
	end

	def show
		render 'index'
		@executes = Execute.all
	end

	def index
		@executes = Execute.all
	end

# A status code 0 means good to be executed.
# A status code 3 means executed.
# A status code 5 means an error.

	def execution
		#Test admin here.
		if (1)

			puts("Passed Admin!")
			_buy_coef = 1.001
			_sell_coef = 1.0

			Execute.all.each do |order|

				if ( order.volume != nil && order.securityID != nil)
					puts("here2")

					@Xportfolio = Portfolio.find(order.portfolio_id)
					@Xuser = @Xportfolio.user
					@Xsecurity = Security.find(order.securityID)

					_volume = order.volume
					_status = order.status
					_security = order.securityID
					_price = @Xsecurity.price

					_asset_id_in_portfolio = 0

					if (@Xportfolio.assets.count != 0)
						@Xportfolio.assets.each do |asset|
							if asset.sec == _security
								_asset_id_in_portfolio = asset.id
							end
						end
					end

					if (_asset_id_in_portfolio == 0)
						_asset_id_in_portfolio = false
					end

					if ( _status == 0 || _status == 1 )
						if (_volume > 0.0)

							if (@Xportfolio.cashAUD >= _volume * _price * _buy_coef)

								if (!_asset_id_in_portfolio)
									
									new_asset = @Xportfolio.assets.create(sec: _security, volume: _volume, ticker: @Xsecurity.ticker, title: @Xsecurity.title)
									_asset_id_in_portfolio = new_asset.id	

								end
								@Xportfolio.assets.find(_asset_id_in_portfolio).update_attributes(volume: _volume)
								@Xportfolio.update_attributes(cashAUD: @Xportfolio.cashAUD - _volume*_price*_buy_coef)
								order.update_attributes(status: 3)

							else
								puts("Insufficient funds")
								order.update_attributes(status: 5)
							end

						elsif (_asset_id_in_portfolio)
							_volume *= -1

							if (@Xportfolio.assets.find(_asset_id_in_portfolio).volume > _volume)
								
								@Xportfolio.update_attributes(cashAUD: @Xportfolio.cashAUD + _volume * _price)
					
								@Xportfolio.assets.find(_asset_id_in_portfolio).update_attributes(volume: @Xportfolio.assets.find(_asset_id_in_portfolio).volume - _volume)

								order.update_attributes(status: 3)

							else
								#THIS NEEDS FIXING
								@Xportfolio.update_attributes(cashAUD: @Xportfolio.cashAUD+@Xportfolio.assets.find(_asset_id_in_portfolio).volume*_price)

								@Xportfolio.assets.find(_asset_id_in_portfolio).update_attributes(volume: 0.00)
								order.update_attributes(status: 3)

							end

						end

					end

				end

			end

		end

		redirect_to root_url

	end

	private

		def execute_params
			params.require(:execute).permit(:transType, :transArg, :sec, 
  				:volume)
		end

end
