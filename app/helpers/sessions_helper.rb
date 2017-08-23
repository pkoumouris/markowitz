module SessionsHelper

	# Logs in user
	def log_in(user)
		session[:user_id] = user.id
	end

	# Returns true if the given user is the current user.
	def current_user?(user)
		user == current_user
	end

	# Returns the current logged-in user (if any).
	def current_user
		@current_user ||= User.find_by(id: session[:user_id])
	end

	# Returns true if the user is logged in, false otherwise.
	def logged_in?
		!current_user.nil?
	end

	#Returns true if the user is admin.
	def logged_in_admin?
		if current_user.id == 1
			return true
		else
			return false
		end
	end

	def log_out
		session.delete(:user_id)
		@current_user = nil
	end

	def redirect_back_or(default)
		redirect_to(session[:forwarding_url] || default)
		session.delete(:forwarding_url)
	end

	def store_location
		session[:forwarding_url] = request.original_url if request.get?
	end
end
