class Api::GroupsController < ApiController
  before_filter :verify_groups_params, :except => [:create, :get_by_user]
  before_filter :verify_token
  before_filter :verify_group, :except => [:create, :get_by_user]
  
  def get_users
    authorize! :update, @group
    render :xml => Group.get_users(@group)
  end
  
  def get_pending_users
    authorize! :update, @group
    render :xml => Group.get_pending_users(@group)
  end
  
  def get_active_users
    authorize! :update, @group
    render :xml => Group.get_active_users(@group)
  end
  
  def join
    authorize! :join, @group
    render :xml => Group.join(@game_user, @group)
  end

  def get_by_user
    render :xml => Group.get_by_user(params[:username])
  end
  
  def invite
    authorize! :invite_to, @group
    render :xml => Group.invite(params[:username], params[:game_user_id], @group)
  end
  
  def accept_invite
    gug = GameUserGroup.where(:game_user_id => @game_user.id, :group_id => @group.id).first
    authorize! :accept_invite, gug
    render :xml => Group.accept_invite(gug)
  end
  
  def reject_invite
    gug = GameUserGroup.where(:game_user_id => @game_user.id, :group_id => @group.id).first
    authorize! :accept_invite, gug
    render :xml => Group.reject_invite(gug)
  end
  
  def accept_member
    game_user = GameUser.find(params[:accept_game_user_id])
    gug = GameUserGroup.where(:game_user_id => game_user.id, :group_id => @group.id).first
    authorize! :accept_member, gug
    render :xml => Group.accept_member(gug)
  end
  
  def reject_member
    game_user = GameUser.find(params[:reject_game_user_id])
    gug = GameUserGroup.where(:game_user_id => game_user.id, :group_id => @group.id).first
    authorize! :accept_member, gug
    render :xml => Group.reject_member(gug)
  end
  
  def remove_member
    game_user = GameUser.find(params[:joined_user_id])
    gug = GameUserGroup.where(:game_user_id => game_user.id, :group_id => @group.id).first
    authorize! :accept_member, gug
    render :xml => Group.remove_member(gug)
  end
  
  def make_admin
    game_user = GameUser.find(params[:joined_user_id])
    gug = GameUserGroup.where(:game_user_id => game_user.id, :group_id => @group.id).first
    authorize! :accept_member, gug
    render :xml => Group.make_admin(gug)
  end
  
  def create
    render :xml => Group.create_group(@game_user, params)
  end
  
  def remove
    authorize! :destroy, @group
    render :xml => @group.destroy
  end
  
  private
  
  
  def verify_groups_params
    unless params.has_key?(:token) && params.has_key?(:group_id)
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