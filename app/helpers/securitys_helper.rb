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

end
