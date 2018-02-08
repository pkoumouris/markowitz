class Api::UsersController < ApplicationController
	skip_before_action :verify_authenticity_token
	def show
		@user = User.find(params[:id])

		_securities = []
		_used_tickers = []

		@user.portfolios.each do |portfolio|

			portfolio.assets.each do |asset|
				if !!(_used_tickers.include?(Security.find(asset.sec).ticker))
					_securities.each do |security|
						if security[:ticker] == Security.find(asset.sec).ticker
							security[:volume] += asset.volume
						end
					end
				else
					_securities.push(
						{
							ticker: Security.find(asset.sec).ticker,
							name: Security.find(asset.sec).title,
							price: Security.find(asset.sec).price,
							volume: asset.volume
						}
					)
					_used_tickers.push(Security.find(asset.sec).ticker)
				end
			end

		end

		historical_values = user_value_hist(_securities, @user)
		_user_value = user_value(@user)

		render json: {
			value: _user_value,
			cash: @user.balanceAUD,
			historyWeek: historical_values[:historyWeek],
			historyMonth: historical_values[:historyMonth],
			historyYear: historical_values[:historyYear],
			expRet: user_exp_ret(_securities, _user_value),
			stdDev: 0.40,
			mktCorr: 0.45
		}.to_json
	end

	def update
		if !!params[:id] && !!params[:type] && params[:type] == "cashTransfer"
			
			
			good_request = !!params[:data][:value] && !!params[:data][:portfolioName] && !!User.find(params[:id]).portfolios.find_by(title: params[:data][:portfolioName])
			
			if good_request
				puts "THIS IS GOOD at least"
			end

			user = User.find(params[:id])
			portfolio = user.portfolios.find_by(title: params[:data][:portfolioName])

			if good_request

				#transfer_data = params[:data]
				transfer_value = (params[:data][:value].to_s).to_f
				if transfer_value > 0 #deposit account->PF
					if transfer_value > user.balanceAUD
						render json: {
							status: 401,
							error: "Insufficient account funds to process request."
						}
					else
						user.update_attributes(balanceAUD: user.balanceAUD - transfer_value)
						portfolio.update_attributes(cashAUD: portfolio.cashAUD + transfer_value)
						render json: {
							status: 200
						}
					end
				else
					if transfer_value > portfolio.cashAUD
						render json: {
							status: 401,
							error: "Insufficient portfolio funds to process request."
						}
					else
						user.update_attributes(balanceAUD: user.balanceAUD - transfer_value)
						portfolio.update_attributes(cashAUD: portfolio.cashAUD + transfer_value)
						render json: {
							status: 200
						}
					end
				end
			else
				render json: {
					status: 401,
					error: "Unspecified"
				}
			end
		end
	end

	private

		def user_value(user)
			_value = user.balanceAUD

			user.portfolios.each do |portfolio|

				portfolio.assets.each do |asset|
					_value += asset.volume * Security.find(asset.sec).price
				end

				_value += portfolio.cashAUD

			end

			return _value
		end

		def user_exp_ret(securities, _user_value)

			_weight = 0.0

			securities.each do |security|
				_weight += security[:volume] * security[:price] * Security.find_by(ticker: security[:ticker]).expreturn
			end

			_weight /= _user_value

			return _weight
		end

		def user_value_hist(securities, user)

			_history_week = []

			day7count = 0
			day7date = Time.now

			while day7count <= 5

				add_it = true

				securities.each do |security|
					if !Security.find_by(ticker: security[:ticker]).interdays.find_by(date: ((day7date.to_s).split)[0])
						add_it = false
						day7date -= 1.day
						break
					end
				end

				if add_it

					_value = 0.0

					securities.each do |security|
						puts "here1"
						_value += Security.find_by(ticker: security[:ticker]).interdays.find_by(date: ((day7date.to_s).split)[0]).close * security[:volume]
					end

					#Will have to do CA$H differently
					user.portfolios.each do |portfolio|
						_value += portfolio.cashAUD
					end
					_value += user.balanceAUD

					_history_week.push({date: ((day7date.to_s).split)[0], value: _value})

					day7count += 1
					day7date -= 1.day

				end

			end

			_history_month = []

			day30count = 0
			day30date = Time.now

			while day30count <= 22

				add_it = true

				securities.each do |security|
					if !Security.find_by(ticker: security[:ticker]).interdays.find_by(date: ((day30date.to_s).split)[0])
						add_it = false
						day30date -= 1.day
						break
					end
				end

				if add_it

					_value = 0.0

					securities.each do |security|
						puts "here2"
						_value += Security.find_by(ticker: security[:ticker]).interdays.find_by(date: ((day30date.to_s).split)[0]).close * security[:volume]
					end

					#Will have to do CA$H differently
					user.portfolios.each do |portfolio|
						_value += portfolio.cashAUD
					end
					_value += user.balanceAUD

					_history_month.push({date: ((day30date.to_s).split)[0], value: _value})

					day30count += 1
					day30date -= 1.day

				end

			end

			_history_year = []

			day365count = 0
			day365date = Time.now

			while day365count <= 52

				add_it = true

				securities.each do |security|
					if !Security.find_by(ticker: security[:ticker]).interdays.find_by(date: ((day365date.to_s).split)[0])
						add_it = false
						day365date -= 1.day
						break
					end

				end

				if add_it

					_value = 0.0

					securities.each do |security|
						puts "here3"
						_value += Security.find_by(ticker: security[:ticker]).interdays.find_by(date: ((day365date.to_s).split)[0]).close * security[:volume]
					end

					#Will have to do CA$H differently
					user.portfolios.each do |portfolio|
						_value += portfolio.cashAUD
					end
					_value += user.balanceAUD

					_history_year.push({date: ((day365date.to_s).split)[0], value: _value})

					day365count += 1
					day365date -= 7.days

				end

			end

			return {
				historyWeek: _history_week,
				historyMonth: _history_month,
				historyYear: _history_year
			};

		end

end