require 'open3'

class Api::PortfoliosController < ApplicationController
	#These just here for now, may/may not need later
	skip_before_action :verify_authenticity_token
	def index
		render json: Portfolio.all
	end

	def show
		if !!params[:id]

			securities = []
			_ticker = ''
			_name = ''
			_price = 0.0
			_volume = 0.0

			_history_day = [{value: 25000}, {value: 24500}, {value: 24875}]
			_history_week = _history_day



			_history_month = _history_week
			_history_year = _history_month

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

			render json: {value: portfolio_value(params[:id]),
				cash: Portfolio.find(params[:id]).cashAUD,
				securities: securities,
				historyDay: _history_day,
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