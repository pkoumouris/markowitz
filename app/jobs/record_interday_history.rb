require 'open3'

class RecordInterdayHistory < ApplicationJob
	#queue_as :default

	def perform()
		_output = Open3.capture2('python pricelister2.py')
		_output = _output[0]
		#print _output

		_output = _output.split("\n")
		print _output[0]

		_output.each do |hist_entry|
			entry = hist_entry.split

			if !!Security.find_by(ticker: entry[0]).interdays.find_by(date: entry[1]) && !!Security.find_by(ticker: entry[0])
				interday = Security.find_by(ticker: entry[0]).interdays.find_by(date: entry[1])
				interday.update_attributes(open: entry[2], high: entry[3], low: entry[4], close: entry[5])
			elsif !!Security.find_by(ticker: entry[0])
				Security.find_by(ticker: entry[0]).interdays.create(date: entry[1], open: entry[2], high: entry[3], low: entry[4], close: entry[5])
			end

		end
	end
end