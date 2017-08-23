class SecuritysController < ApplicationController

	def show
		@security = Security.find(params[:id])
	end

end
