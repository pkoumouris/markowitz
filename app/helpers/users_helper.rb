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
end
