class Api::CollectionsController < ApiController
	# See API Documentation on Basecamp
	
  before_filter :verify_token
  before_filter :verify_group
  before_filter :verify_collection_params, :only => [:create_collection]
  before_filter :verify_edit_params, :only => [:edit_collection]
  before_filter :verify_remove_params, :only => [:remove_collection]
  
  def create
    authorize! :create_collection, @group
    render :xml => Collection.create_collection(@game_user, @group, params[:description])
  end
  
  def remove
    authorize! :create_collection, @group
    render :xml => Collection.remove_collection(@group, params[:collection_id])
  end
  
  def edit
    authorize! :create_collection, @group
    render :xml => Collection.edit_collection(@group, params[:description], params[:collection_id])
  end
  
  private 
  
  def verify_edit_params
    unless params.has_key?(:token) && params.has_key?(:group_id) && params.has_key?(:collection_id) && params.has_key?(:description)
      error = Error.create(:error_type_id => '2', :name => 'Parameter failure.', :description => 'Incorrect number of parameters.  Please check them.')
      render :xml => error.to_xml(:only => [:error_type_id, :name, :description, :created_at])
    end
  end
  
  def verify_remove_params
    unless params.has_key?(:token) && params.has_key?(:group_id) && params.has_key?(:collection_id)
      error = Error.create(:error_type_id => '2', :name => 'Parameter failure.', :description => 'Incorrect number of parameters.  Please check them.')
      render :xml => error.to_xml(:only => [:error_type_id, :name, :description, :created_at])
    end
  end
  
  def verify_collection_params
    unless params.has_key?(:token) && params.has_key?(:group_id) && params.has_key?(:description)
      error = Error.create(:error_type_id => '2', :name => 'Parameter failure.', :description => 'Incorrect number of parameters.  Please check them.')
      render :xml => error.to_xml(:only => [:error_type_id, :name, :description, :created_at])
    end
  end
  
  def verify_token
    #Refactor
    
    @token = AuthToken.find_by_token(params[:token])
    if @token.nil? || !@token.deleted_at.nil?
      error = Error.create(:error_type_id => '3', :name => 'AuthToken Error', :description => 'That token was either expired or not found.')
      render :xml => error.to_xml(:only => [:error_type_id, :name, :description, :created_at])    
    else
      @game_user = @token.game_user
    end
    
  end
  
  def verify_group
    group = Group.find_by_id(params[:group_id])
    if group.blank?
      error = Error.create(:error_type_id => '4', :name => 'Group Error', :description => 'Invalid group.')
      render :xml => error.to_xml(:only => [:error_type_id, :name, :description, :created_at])   
    else
      @group = group
      @current_ability ||= GroupAbility.new(@game_user, @group)
    end
  end
  
end