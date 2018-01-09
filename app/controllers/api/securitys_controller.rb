require 'open3'

class Api::SecuritysController < ApplicationController
	skip_before_action :verify_authenticity_token

	def show
		if !!params[:id]
			security = Security.find(params[:id])

			_ticker = security.ticker
			_name = security.title
			_description = security.description
			_price = security.price
			_expret = security.expreturn
			_stddev = security.stddev
			_last_dividend = security.dividend
			_div_yield = security.divyield
			_num_shares = security.numshares
			_mkt_correlation = security.mktcorr

			_history_week = [{}]
			_history_month = [{}]
			_history_year = [{}]

			security.interdays.each do |interday|
				if interday.date > 1.week.ago
					_history_week.push({
						date: interday.date,
						price: interday.close
					})
				end
				if interday.date > 1.month.ago
					_history_week.push({
						date: interday.date,
						price: interday.close
					})
				end
				if interday.date > 1.year.ago
					_history_week.push({
						date: interday.date,
						price: interday.close
					})
				end
			end

			render json: {
				ticker: _ticker,
				name: _name,
				description: _description,
				price: _price,
				expret: _expret,
				stddev: _stddev,
				lastDividend: _last_dividend,
				divYield: _div_yield,
				numShares: _num_shares,
				mktCorrelation: _mkt_correlation,
				historyWeek: _history_week,
				historyMonth: _history_month,
				historyYear: _history_year
			}.to_json
		end
	end
end