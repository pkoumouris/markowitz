require 'open3'

class Api::PortfoliosController < ApplicationController
	#These just here for now, may/may not need later
	skip_before_action :verify_authenticity_token
	def index
		render json: Portfolio.all
	end

	def show
		if !!params[:id]

			portfolio = Portfolio.find(params[:id])

			securities = []
			_ticker = ''
			_name = ''
			_price = 0.0
			_volume = 0.0

			_history_week = []



			#_history_day = [{value: 25000}, {value: 24500}, {value: 24875}]
			#_history_week = _history_day



			#_history_month = _history_week
			#_history_year = _history_month

			_exp_ret = 0.12
			_std_dev = 0.22

			Portfolio.find(params[:id]).assets.each do |asset|
				_ticker = Security.find(asset.sec).ticker
				_name = Security.find(asset.sec).title
				_price = Security.find(asset.sec).price
				_volume = asset.volume

				securities.push({
					ticker: _ticker,
					name: _name,
					price: _price,
					volume: _volume
				})

			end

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

					_value += portfolio.cashAUD

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

					_value += portfolio.cashAUD

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

					_value += portfolio.cashAUD

					_history_year.push({date: ((day365date.to_s).split)[0], value: _value})

					day365count += 1
					day365date -= 7.days

				end

			end

			#securities.each do |security|
			#	_volume = security[:volume]

			#	historyList = Security.find_by(ticker: security[:ticker]).interdays.order("date ASC")

			#	historyList.each do |record|
			#		recorded = false
			#		rec_index = 0

			#		_history.each do |hist|
			#			if hist[:date] == record.date
			#				hist[:value] += _volume * record.close
			#				recorded = true
			#				break
			#			end
			#		end

			#		if !recorded
			#			_history.push({date: record.date, value: _volume*record.close})
			#		end

			#	end
			#end

			render json: {value: portfolio_value(params[:id]),
				cash: Portfolio.find(params[:id]).cashAUD,
				securities: securities,
				historyWeek: _history_week,
				historyMonth: _history_month,
				historyYear: _history_year,
				expRet: _exp_ret,
				stdDev: _std_dev
				}.to_json
		end
	end

	def update
	# This is /api/portfolios/:id POST
		@portfolio = Portfolio.find(params[:id])
		
		if proposal?
			
			if params[:data][:type] == 'individualvolume'

				
				render json: {place: "hello"}.to_json

			elsif params[:data][:type] == 'individualvalue'

			elsif params[:data][:type] == 'optimise'

				if !!params[:data][:preferences][:stddev]
					weights = []
					_stddev = params[:data][:preferences][:stddev]

					_output = Open3.capture2('python optimal_ret.py '+_stddev)

					_output = _output[0]
					_output = _output.split
					_output_stddev = 0.0
					_output_ret = 0.0

					_output.each_with_index do |entry,myIndex|
						if entry.include?(":") && _output[myIndex+1].to_f>0.005
							_sec = {ticker: entry, weight: _output[myIndex+1],
								name: Security.find_by(ticker: entry).title}
							weights.push(_sec)
						elsif entry.include?("stdde")
							_output_stddev = _output[myIndex+1].to_f
						elsif entry.include?("re")
							_output_ret = _output[myIndex+1].to_f
						end
					end

					render json: {
						status: 200,
						proposal: {
							securities: weights,
							stddev: _output_stddev,
							ret: _output_ret
						}
					}.to_json
				end

			end
		
		else

			render json: {status: 403}.to_json

		end

	end

	private

	def portfolio_params
		params.require(:portfolio).permit(:title, :description, :initial)
	end

	def proposal?
		!!params[:requestType] && !!params[:id] && !!params[:data] && params[:requestType] == 'proposal'
	end

	def correct_user_portfolio?

		current_user.portfolios.each do |portfolio|
			if portfolio.id == params[:id].to_i
				return true
			end
		end
		return false
	end

	def portfolio_value(pf_id)
		_value = Portfolio.find(pf_id).cashAUD
		Portfolio.find(pf_id).assets.each do |asset|
			_value += Security.find(asset.sec).price * asset.volume
		end

		return _value
	end
end