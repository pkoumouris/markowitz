class Security < ApplicationRecord
	has_many :intradays
	has_many :interdays
end
