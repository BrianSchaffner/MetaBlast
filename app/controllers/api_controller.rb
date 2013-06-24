class ApiController < ApplicationController
  skip_before_filter :authenticate_game_user!
	
	def patch_notes
		render :xml => PatchNote.add_notes(params)
	end
	
end