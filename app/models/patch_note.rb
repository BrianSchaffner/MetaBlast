class PatchNote < ActiveRecord::Base

	def self.add_notes(params)
		if params.has_key?(:secret_password) && params[:secret_password] == 'zxc7892345hjksdf76834thjks' && params.has_key?(:notes) && params.has_key?(:version)
			notes = PatchNote.create(:notes => params[:notes], :version => params[:version])
			notes.to_xml
		else
      error = Error.create(:error_type_id => '111', :name => 'Patch Note Failure', :description => 'Check your parameters.')
    	error.to_xml(:only => [:error_type_id, :name, :description, :created_at])
		end
	end
	
end
