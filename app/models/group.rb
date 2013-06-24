class Group < ActiveRecord::Base
  has_many :game_user_groups, :dependent => :destroy
  has_many :game_users, :through => :game_user_groups
  has_many :collections
	belongs_to :owner, :class_name => 'GameUser'
  
  validates_presence_of :name
  validates_uniqueness_of :name
	
	attr_protected :deleted_at
  
  def self.get_users(group)
    role_proc = Proc.new {|options, record| options[:builder].tag!('game-role-id', record.game_user_groups.where(:group_id => group.id).first.game_role.id)}
    game_user_proc = Proc.new {|options, record| options[:builder].tag!('id', record.id)}
    state_proc = Proc.new {|options, record| options[:builder].tag!('state', record.game_user_groups.where(:group_id => group.id).first.state)}
    group.game_users.to_xml(:procs => [role_proc, state_proc, game_user_proc])
  end
  
  def self.get_active_users(group)
    role_proc = Proc.new {|options, record| options[:builder].tag!('game-role-id', record.game_user_groups.where(:group_id => group.id).first.game_role.id)}
    game_user_proc = Proc.new {|options, record| options[:builder].tag!('id', record.id)}
    group.game_user_groups.where(:state => 'accepted').map(&:game_user).to_xml(:procs => [role_proc, game_user_proc])
  end
  
  def self.get_pending_users(group)
    role_proc = Proc.new {|options, record| options[:builder].tag!('game-role-id', record.game_user_groups.where(:group_id => group.id).first.game_role.id)}
    game_user_proc = Proc.new {|options, record| options[:builder].tag!('id', record.id)}
    state_proc = Proc.new {|options, record| options[:builder].tag!('state', record.game_user_groups.where(:group_id => group.id).first.state)}
    pending = group.game_user_groups.where(:state => 'pending_approval')
    invites = group.game_user_groups.where(:state => 'invite_pending')
    all_users = pending + invites
    all_users.map(&:game_user).to_xml(:procs => [role_proc, game_user_proc, state_proc])
  end  
  
  def self.join(game_user, group)
    role = GameRole.find_by_name('Member')
    gug = GameUserGroup.create(:game_user_id => game_user.id, :game_role_id => role.id, :group_id => group.id)
    gug.join_group
    gug
  end
  
  def self.invite(username, game_user_id, group)
    invited_user = GameUser.find_by_username(username);
    game_user = GameUser.find_by_id(game_user_id)
    role = GameRole.find_by_name('Member')
    gug = GameUserGroup.create(:game_user_id => invited_user.id, :inviter_id => game_user.id, :game_role_id => role.id, :group_id => group.id)
    gug.invite_to_group
    gug
  end

  def self.get_by_user(username)
    game_user = GameUser.find_by_username(username)
    game_user.groups
  end
  
  def self.accept_invite(gug)
    gug.accept_invite
    gug
  end
  
  def self.reject_invite(gug)
    gug.reject_invite
    gug
  end
  
  def self.accept_member(gug)
    gug.accept_member
    gug
  end
  
  def self.reject_member(gug)
    gug.reject_member
    gug
  end
  
  def self.remove_member(gug)
    gug.remove_member
    gug
  end
  
  def self.make_admin(gug)
    role = GameRole.find_by_name('Admin')
    gug.game_role_id = role.id
    if gug.save
      gug
    else
      error = Error.create(:error_type_id => '4', :name => 'Admin Creation Creation Failure', :description => gug.errors)
      error.to_xml(:only => [:error_type_id, :name, :description, :created_at])
    end
  end
  
  def self.create_group(game_user, params)
    group = Group.new(params[:group])
    group.owner_id = game_user.id
    if group.save
      role = GameRole.find_by_name('Owner')
      gug = GameUserGroup.create(:game_user_id => game_user.id, :game_role_id => role.id, :group_id => group.id, :state => 'accepted')
      gug.created_group
      group
    else
      error = Error.create(:error_type_id => '4', :name => 'Group Creation Failure', :description => group.errors)
      error.to_xml(:only => [:error_type_id, :name, :description, :created_at])
    end
  end
	
	def self.find_by_email(email)
		game_user = GameUser.find_by_email(email)
		if game_user.nil?
			return []
		else
			game_user.get_admin_groups + game_user.get_owner_groups
		end
	end
  
end
