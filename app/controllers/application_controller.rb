class ApplicationController < ActionController::Base
  protect_from_forgery
	before_filter :authenticate_game_user!
	enable_authorization :unless => :devise_controller?

	def current_ability
		@current_ability ||= Ability.new(current_game_user)
	end
	
end
