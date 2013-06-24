class GameUser < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :username, :age, :postal_code, :gender

  # Devise already validates presence of e-mail and password.
  validates_uniqueness_of :username 
  validates_presence_of :username
  
  has_many :auth_tokens
  has_many :game_user_groups
  has_many :game_roles, :through => :game_user_groups
  has_many :groups, :through => :game_user_groups
  has_many :game_user_answers
  has_many :answers, :through => :game_user_answers
  has_many :questions
  has_many :statistics
	
	after_create :join_default_group

  
  
  #JAF: 'user' is actually 'GameUser' - not to be confused with the User model.  Simpler to type.
  def self.login(username, password)
    user = GameUser.find_by_username(username)

    case user
      when nil
        # This is specifically username doesn't exist, but for security reasons we use a generic message.
        error = Error.create(:error_type_id => '1', :name => 'Login Failure', :description => 'Incorrect login/password combination.')
        error.to_xml(:only => [:error_type_id, :name, :description, :created_at])        
      else
        if user.valid_password?(password)
          auth_token = AuthToken.create_new_token(user)
          auth_token
        else
          error = Error.create(:error_type_id => '1', :name => 'Login Failure', :description => 'Incorrect login/password combination.')
          error.to_xml(:only => [:error_type_id, :name, :description, :created_at])
        end
      end
      
  end
  
  def self.logout(token)
    if token.expire
      token
    end
  end 
	
	def join_default_group
		unless self.groups.length > 0
	  	self.groups << Group.find_by_name('Meta!Blast');
	    gug = self.game_user_groups.first
	    gug.game_role_id = GameRole.find_by_name('Member').id
	    gug.state = 'accepted'
	    gug.save(:validate => false)
		end
	end
  
  def self.sign_up(params)
    game_user = GameUser.new(params)
    if game_user.save
      game_user.groups << Group.find_by_name('Meta!Blast');
      gug = game_user.game_user_groups.first
      gug.game_role_id = GameRole.find_by_name('Member').id
      gug.state = 'accepted'
      gug.save(:validate => false)
      game_user
    else
      error = Error.create(:error_type_id => '1', :name => 'Account Creation Failure', :description => game_user.errors)
      error.to_xml(:only => [:error_type_id, :name, :description, :created_at])
    end
  end

  #REFACTOR, currently broken
  def is_super_user?
    super_role = GameRole.find_by_name('SuperUser')
    self.game_roles.map(&:name).include?(super_role)
  end
  
	def get_group_admin_ids
		admin_role = GameRole.find_by_name('Admin')
		self.game_user_groups.where(:game_role_id => admin_role.id).map(&:group).map(&:id)
	end
	
	def get_admin_groups
		admin_role = GameRole.find_by_name('Admin')
		self.game_user_groups.where(:game_role_id => admin_role.id).map(&:group)
	end
	
	def get_owner_groups
		admin_role = GameRole.find_by_name('Owner')
		self.game_user_groups.where(:game_role_id => admin_role.id).map(&:group)
	end
	
	def get_group_owner_ids
		owner_role = GameRole.find_by_name('Owner')
		self.game_user_groups.where(:game_role_id => owner_role.id).map(&:group).map(&:id)
	end
  
  def active_groups
    self.game_user_groups.where(:state => 'accepted').map(&:group)
  end
  
  def pending_groups
    self.game_user_groups.where(:state => 'pending_approval').map(&:group)
  end
  
  def owner_in_group?(group)
    owner_role = GameRole.find_by_name('Owner')
    self.game_user_groups.where(:group_id => group.id).map(&:game_role).include?(owner_role)
  end
  
  def admin_in_group?(group)
    admin_role = GameRole.find_by_name('Admin')
    self.game_user_groups.where(:group_id => group.id).map(&:game_role).include?(admin_role)
  end
  
  def role_id_for_group(group)
    self.game_user_groups.where(:group_id => group.id).first.game_role_id
  end
  
  def self.role_proc(game_user)
    Proc.new {|options, record| options[:builder].tag!('role', game_user.role_id_for_group(record))}
  end

  def self.get_groups(game_user)
    game_user.game_user_groups.to_xml(:include => {:group => {:include => :collections}})
    #game_user.groups.to_xml(:procs => [GameUser.role_proc(game_user)], :include => [:collections])
  end
  
  def self.get_pending_groups(game_user)
    game_user.pending_groups.to_xml(:include => {:group => {:include => :collections}})
  end
  
  def self.get_active_groups(game_user)
    game_user.active_groups.to_xml(:include => {:group => {:include => :collections}})
  end
  
  def self.get_questions(game_user)
    game_user.questions.to_xml
  end
	
	def self.check_pending_invites(game_user, group)
	
		if game_user.nil?
			return true
		end
		
		potential_gugs = GameUserGroup.where(:game_user_id => game_user.id, :group_id => group.id)
		
		if potential_gugs.empty?
			return false
		else
			return true
		end
		
	end
	
	def invite_to_group(group)
		pending_role = GameRole.find_by_name('Pending')
		gug = GameUserGroup.create(:game_user_id => self.id, :game_role_id => pending_role.id, :group_id => group.id)
		gug.invite_to_group
		gug
	end
  
	def get_member_of_group_ids
		self.game_user_groups.where(:state => 'accepted').map(&:group_id)
	end
  
    
  
end
