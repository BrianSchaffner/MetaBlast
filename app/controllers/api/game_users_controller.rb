class Api::GameUsersController < ApiController
	# See API Documentation on Basecamp
  respond_to :xml
  
  before_filter :verify_login_params, :only => [:login]
  before_filter :verify_token, :only => [:logout, :get_groups, :get_pending_groups, :get_active_groups, :get_questions]
  
  def login
    render :xml => GameUser.login(params[:username], params[:password])
  end 
  
  def logout
    render :xml => GameUser.logout(@token)
  end
  
  def sign_up
    # No params check required, handled by the model (will return an error if no params exist, since this is a creation of a row not a reference).
    render :xml => GameUser.sign_up(params)
  end
  
  def get_groups
    render :xml => GameUser.get_groups(@game_user)
  end
  
  def get_pending_groups
    render :xml => GameUser.get_pending_groups(@game_user).to_xml(:include => {:group => {:include => :collections}})
  end
  
  def get_active_groups
    render :xml => GameUser.get_active_groups(@game_user).to_xml(:include => {:group => {:include => :collections}})
  end
  
  def get_questions
    render :xml => GameUser.get_questions(@game_user)
  end
  
  private
  
  def verify_token
    @token = AuthToken.find_by_token(params[:token])
    if @token.nil? || !@token.deleted_at.nil?
      error = Error.create(:error_type_id => '3', :name => 'AuthToken Error', :description => 'That token was either expired or not found.')
      render :xml => error.to_xml(:only => [:error_type_id, :name, :description, :created_at])    
    else
      @game_user = @token.game_user
    end
  end
  
  def verify_login_params
    unless params.has_key?(:username) && params.has_key?(:password)
      error = Error.create(:error_type_id => '2', :name => 'Parameter failure.', :description => 'Incorrect number of parameters.  Please check them.')
      render :xml => error.to_xml(:only => [:error_type_id, :name, :description, :created_at])
    end
  end
  
end