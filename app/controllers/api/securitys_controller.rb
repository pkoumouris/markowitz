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

			_history = security.interdays.order("date ASC")

			_history_week = []
			_history_month = []
			_history_year = []

			



			day7count = 0
			day7date = Time.now

			while day7count <= 5
				if !!Security.find(params[:id]).interdays.find_by(date: ((day7date.to_s).split)[0])
					_value_open = Security.find(params[:id]).interdays.find_by(date: ((day7date.to_s).split)[0]).open
					_history_week.push({date: ((day7date.to_s).split)[0], price: _value_open})
					_value = Security.find(params[:id]).interdays.find_by(date: ((day7date.to_s).split)[0]).close
					_history_week.push({date: ((day7date.to_s).split)[0], price: _value})
					day7count += 1
				end
				day7date -= 1.day
			end

			day30count = 0
			day30date = Time.now

			while day30count <= 22
				if !!Security.find(params[:id]).interdays.find_by(date: ((day30date.to_s).split)[0])
					_value = Security.find(params[:id]).interdays.find_by(date: ((day30date.to_s).split)[0]).close
					_history_month.push({date: ((day30date.to_s).split)[0], price: _value})
					day30count += 1
				end
				day30date -= 1.day
			end

			day365count = 0
			day365date = Time.now

			while day365count <= 260
				if !!Security.find(params[:id]).interdays.find_by(date: ((day365date.to_s).split)[0])
					_value = Security.find(params[:id]).interdays.find_by(date: ((day365date.to_s).split)[0]).close
					_history_year.push({date: ((day365date.to_s).split)[0], price: _value})
					day365count += 5
				else
					day365date -= 1.day
				end
				day365date -= 7.days
			end

			all_intraday_values = []
			cardinal_index = 0
			cardinal_indexables = 0

			security.intradays.each do |intraday|
				if intraday.updated
					cardinal_indexables += 1
				end

				t = Time.parse("10:00") + intraday.cardinal360 * 60

				this_time = (((t).to_s).split)[1]

				if intraday.updated

					all_intraday_values.push(
						{
							date: this_time,
							price: intraday.price
						}
					)

				end
			end

			if !(all_intraday_values.length>0)
				all_intraday_values.push(
					date: "Last close",
					price: security.intradays.find_by(cardinal360: 360).price
				)
				all_intraday_values.push(
					date: "Today",
					price: security.intradays.find_by(cardinal360: 360).price
				)
			end

			#_history_day = []

			#if all_intraday_values.length < 30
			#	_history_day = all_intraday_values
			#else

			#end

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
				historyDay: all_intraday_values,
				historyWeek: _history_week,
				historyMonth: _history_month,
				historyYear: _history_year
			}.to_json
		end
	end
end