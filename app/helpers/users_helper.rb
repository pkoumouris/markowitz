module UsersHelper

	def user_value(user)
		_value = user.balanceAUD
		user.portfolios.each do |portfolio|
			_value += portfolio.cashAUD
			portfolio.assets.each do |asset|
				_value += Security.find(asset.sec).price * asset.volume
			end
		end

		return _value
	end

	def portfolio_value(portfolio)
		_value = portfolio.cashAUD

		portfolio.assets.each do |asset|
			_value += Security.find(asset.sec).price * asset.volume
		end

		return _value
	end

	def portfolio_old_value(portfolio, days_ago)

		_value_now = portfolio_value(portfolio)
		_date = Time.now - days_ago.days
		_date_count = 0
		_date_good = false

		while !_date_good

			portfolio.assets.each do |asset|
				security = Security.find(asset.sec)

				if !!security.interdays.find_by(date: _date)
					_date_count += 1
				else
					_date -= 1.day
					break
				end
			end

			if _date_count >= portfolio.assets.count
				_date_good = true
			end

		end

		_value_then = portfolio.cashAUD

		portfolio.assets.each do |asset|
			_value_then += Security.find(asset.sec).interdays.find_by(date: _date).close * asset.volume
		end

		return _value_then

	end
end
