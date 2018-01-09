require 'open3'

class PriceUpdateJob < ApplicationJob
  #queue_as :default

  def perform()
  	puts "Opening quote3.py..."
    _output = Open3.capture2('python3.6 quote3.py')

    puts "Opened quote3.py. Getting main part..."
    _output = _output[0]

    if (_output.include?("ASX") && !(_output.include?("exception")) )
    	puts "Result verified."
	    _output = _output.split

	    _output.each_with_index {|_entry,_index|
	    	if (_entry.include?("ASX") && (_output.size / 2 == Security.count)) && (_output[_index+1].to_f - Security.find_by(ticker: _entry).price).abs / Security.find_by(ticker:_entry).price < 0.05
	    		Security.find_by(ticker: _entry).update_attributes(price: _output[_index+1].to_f)
	    	end
	    }

	    self.class.set(:wait => 20.seconds).perform_later

	else

		puts "ALERT: Error in reading stock prices."

	end

  end
end
