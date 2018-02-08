class IntradayWipeJob < ApplicationJob
	def perform()
		Security.all.each do |security|
			security.intradays.each do |intraday|
				intraday.update_attributes(updated: false)
			end
		end

		puts "All intradays are reset."
	end
end