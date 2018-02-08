class IntradayPriceRecordJob < ApplicationJob

	def perform()
		seconds_past_ten = Time.now.seconds_since_midnight.to_i #86400 seconds in a day
		seconds_past_ten -= 10*3600 #adjust for ten o'clock
		#seconds_past_ten += 11*3600 #adjust for +1100 GMT (Melbourne Australia)

		cardinal_block = (360 * seconds_past_ten / 21600).to_i

		if seconds_past_ten > 0 && seconds_past_ten < 21600
			Security.all.each do |security|
				security.intradays.each do |intraday|
					if intraday.cardinal360 < cardinal_block
						if !intraday.updated
							intraday.update_attributes(price: security.price, updated: true)
						end
					else
						break
					end
				end
			end
		else
			puts "Did not pass first qualification."
			puts seconds_past_ten
		end

		if seconds_past_ten > 0 && seconds_past_ten < 21600
			self.class.set(:wait => 30.seconds).perform_later
		else
			puts "Did not pass second qualification."
		end
	end
end