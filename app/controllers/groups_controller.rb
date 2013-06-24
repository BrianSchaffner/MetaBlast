class GroupsController < ApplicationController
	# All of the 'RESTful' actions will use this LAAR to handle the authorization.
	# The rest of the non RESTful sorts will use an authorize! line.
	load_and_authorize_resource
	
	respond_to :html
	
  def index

  end
	
  def show
		@pending_joins = @group.game_user_groups.where(:state => 'pending_approval')
  end

  def new

  end

  def edit
	
  end

  def create
		@group.owner = current_game_user
		
		if @group.save
			flash[:notice] = 'Group was successfully created.' 
			current_game_user.game_user_groups << GameUserGroup.create(:game_role_id => GameRole.find_by_name('Owner').id, :group_id => @group.id)
		end
		
		respond_with(@group)
  end
	
  def update
		flash[:notice] = 'Group was successfully updated.' if @group.update_attributes(params[:group])
		respond_with(@group)
  end

  def destroy
		flash[:notice] = 'Group was succesfully removed.' if @group.destroy
		respond_with(@group, :location => root_path)
  end
	
	def members
		# Set LAAR since this is non RESTFUL
		@group = Group.find(params[:group_id])
		authorize! :access, @group
		@members = @group.game_users
	end
	
	def remove_member
		group = Group.find(params[:group_id])
		game_user = GameUser.find(params[:game_user_id])
		gug = GameUserGroup.where(:game_user_id => game_user.id, :group_id => group.id).first
		authorize! :access, group
		
		if gug.destroy
			flash[:notice] = 'User successfully removed.'
			redirect_to group
		end
		
	end
	
	def invite
		@group = Group.find(params[:group_id])
	end
	
	def send_invite
		group = Group.find(params[:group_id])
		game_user = GameUser.find_by_email(params[:email])
		pending_role = GameRole.find_by_name('Pending')
		
		authorize! :access, group
		
		has_pending_invite = GameUser.check_pending_invites(game_user, group)
		
		case has_pending_invite
		
			when true
				flash[:error] = 'That user is already invited to that group or a user with that e-mail does not exist.'
				
			when false
				flash[:notice] = 'User has been successfully invited to the group.'
				game_user.invite_to_group(group)
				
		end # END case invited
		
		respond_with(group, :location => group_members_path(group))
	
	end
	
	def make_admin
		group = Group.find(params[:group_id])
		game_user = GameUser.find(params[:game_user_id])
		
		#TODO: REFACTOR OUT TO GAMEUSER METHOD (SAME WITH REMOVE)
		@gug = GameUserGroup.where(:game_user_id => game_user.id, :group_id => group.id).first
		admin_role = GameRole.find_by_name('Admin')
		authorize! :access, group
		
		@gug.game_role_id = admin_role.id
		
		if @gug.save
			flash[:notice] = "#{game_user.email} was succesfully added as an admin."
		end
		
		respond_with(@gug, :location => group_members_path(group))
	end
	
	def remove_admin
		group = Group.find(params[:group_id])
		game_user = GameUser.find(params[:game_user_id])
		admin_role = GameRole.find_by_name('Admin')
		member_role = GameRole.find_by_name('Member')
		@gug = GameUserGroup.where(:game_user_id => game_user.id, :group_id => group.id, :game_role_id => admin_role.id).first
		authorize! :access, group
		
		@gug.game_role_id = member_role.id
		
		if @gug.save
			flash[:notice] = "#{game_user.email} was succesfully removed as an admin."
		end
		
		respond_with(@gug, :location => group_members_path(group))
	end
	
	def accept_invite
		@gug = GameUserGroup.find(params[:game_user_group_id])
		authorize! :access, @gug
		
		if @gug.accept_invite
			flash[:notice] = 'You have successfully joined that group!'
		end
		
		respond_with(@gug, :location => group_path(@gug.group))
	end
	
	def reject_invite
		@gug = GameUserGroup.find(params[:game_user_group_id])
		authorize! :access, @gug
		
		if @gug.reject_invite
			flash[:notice] = 'You have successfully declined to join that group!'
			@gug.destroy
		end
		
		respond_with(@gug, :location => root_path)
	end
	
	def accept_member
		@gug = GameUserGroup.find(params[:game_user_group_id])
		authorize! :access, @gug.group
		
		if @gug.accept_member
			flash[:notice] = 'You have successfully accepted that member!'
		end
		
		respond_with(@gug, :location => group_path(@gug.group))
	end
	
	def reject_member
		@gug = GameUserGroup.find(params[:game_user_group_id])
		authorize! :access, @gug.group
		
		if @gug.reject_member
			flash[:notice] = 'You have successfully rejected that member!'
			@gug.destroy
		end
		
		respond_with(@gug, :location => group_path(@gug.group))
	end
	
	def find
	
	
	end
	
	def search
		@groups = Group.find_by_email(params[:email])
	end
	
	def join
		group = Group.find(params[:group_id])
		gug = Group.join(current_game_user, group)
		if gug.instance_of?(GameUserGroup) && gug.errors.empty?
			flash[:notice] = 'Join request succesfully sent to that group.  An admin must confirm your membership.'
		else
			flash[:error] = 'Join request failed.  Are you already a member of that group?'
		end
		respond_with(group, :location => root_path)
	end
	
	def leave
	
	end
	
end
