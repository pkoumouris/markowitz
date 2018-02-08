module SecuritysHelper
	def big_num_string(value, rounding)
		if (value<1000)
			return value.round(rounding).to_s
		elsif (value<1000000)
			return ((value/1000).round(rounding).to_s) + "K"
		elsif (value<1000000000)
			return ((value/1000000).round(rounding).to_s) + "M"
		else
			return ((value)/1000000000).round(rounding).to_s + "B"
		end
	end

	def user_own_security(security)
		_own = 0.0
		current_user.portfolios.each do |portfolio|
			portfolio.assets.each do |asset|
				if (asset.sec == @security.id)
					_own += security.price * asset.volume
				end
			end
		end

		if (_own < 0.01)
			return "$0"
		else
			return number_to_currency(_own)
		end

	end

	def change_last_close(security)
		_price_now = security.price

		_date = Time.now

		while !security.interdays.find_by(date: ((_date.to_s).split)[0])
			_date = _date - 1.day
		end

		return _price_now - security.interdays.find_by(date: ((_date.to_s).split)[0]).close

	end

	def change_last_week(security)
		_price_now = security.price

		_date = Time.now - 7.days

		while !security.interdays.find_by(date: ((_date.to_s).split)[0])
			_date = _date - 1.day
		end

		return _price_now - security.interdays.find_by(date: ((_date.to_s).split)[0]).close
	end

end
