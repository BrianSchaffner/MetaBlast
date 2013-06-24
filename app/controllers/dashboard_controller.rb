class DashboardController < ApplicationController

	def home
		@pending_invites = GameUserGroup.where(:game_user_id => current_game_user.id, :state => 'invite_pending')
	end
	
end
