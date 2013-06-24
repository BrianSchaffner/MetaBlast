class Ability
  include CanCan::Ability
    
  def initialize(game_user)
	  game_user ||=  GameUser.new
      super_user_check = game_user.is_super_user?
    case
      when super_user_check
        super_user_permissions(game_user)
      else
        normal_user_permissions(game_user)
        owner_user_permissions(game_user)
        admin_user_permissions(game_user)
        
    end
  end
 
  # ONLY GRANT WITHIN CONSOLE(RAILS C)
  def super_user_permissions(game_user)
    can :access, :all
    can :create, :all
    can :manage, :all
  end
  
  def normal_user_permissions(game_user)
    member_of_group_ids = game_user.get_member_of_group_ids
    # ACCESS PERMISSIONS
    can :access, :dashboard
    can :access, :game_user_groups, :game_user_id => game_user.id
    can :access, :'api/game_users'
		can :access, :'api/questions'
		can :access, :'api/groups'
		can :access, :'api/statistics'
		can :access, :'api/collections'
		can :access, :'api'
    # READ PERMISSIONS
    can :read, :groups, :id => member_of_group_ids
    # CREATION PERMISSIONS
    can :create, :groups
		can :create, :collections
		can :create, :questions

  end
  
  def admin_user_permissions(game_user)
    group_admin_ids = game_user.get_group_admin_ids
    member_of_group_ids = game_user.get_member_of_group_ids
    # ACCESS PERMISSIONS
    can :access, :dashboard
    can :access, :game_user_groups, :game_user_id => game_user.id
    can :access, :'api/game_users'
		can :access, :'api/questions'
		can :access, :'api/groups'
		can :access, :'api/statistics'
		can :access, :'api/collections'
		can :access, :'api'
    can :access, :groups, :id => group_admin_ids
    can :access, :collections, :group_id => group_admin_ids
    can :access, :questions, :collection => {:group_id => group_admin_ids}
    can :access, :game_users, :game_user_group => {:group_id => group_admin_ids}
    # READ PERMISSIONS
    can :read, :groups, :id => member_of_group_ids
    # CREATION PERMISSIONS
		can :create, :groups
		can :create, :collections
		can :create, :questions
  end  
  
  def owner_user_permissions(game_user)
    group_owner_ids = game_user.get_group_owner_ids
    member_of_group_ids = game_user.get_member_of_group_ids
    # ACCESS PERMISSIONS
    can :access, :dashboard
    can :access, :game_user_groups, :game_user_id => game_user.id
    can :access, :'api/game_users'
		can :access, :'api/questions'
		can :access, :'api/groups'
		can :access, :'api/statistics'
		can :access, :'api/collections'
		can :access, :'api'
    can :access, :groups, :id => group_owner_ids
    can :access, :collections, :group_id => group_owner_ids
    can :access, :questions, :collection => {:group_id => group_owner_ids}
    # READ PERMISSIONS
    can :read, :groups, :id => member_of_group_ids
    # CREATION PERMISSIONS
    can :create, :groups
		can :create, :collections
		can :create, :questions

  end
  

    #All Permissions. Don't uncomment unless defining them within each user case 
  
		# ACCESS PERMISSIONS
		#can :access, :dashboard
		#can :access, :groups, :id => group_admin_ids
		#can :access, :groups, :id => group_owner_ids
		#can :access, :collections, :group_id => group_admin_ids
		#can :access, :collections, :group_id => group_owner_ids
		#can :access, :questions, :collection => {:group_id => group_admin_ids}
		#can :access, :questions, :collection => {:group_id => group_owner_ids}
		#can :access, :game_users, :game_user_group => {:group_id => group_admin_ids}
		#can :access, :game_user_groups, :game_user_id => game_user.id
		
		# READ PERMISSIONS
		#can :read, :groups, :id => member_of_group_ids
		
		# CREATION PERMISSIONS
		#can :create, :groups
		#can :create, :collections
		#can :create, :questions
		
		# API PERMISSIONS
		#can :access, :'api/game_users'
		#can :access, :'api/questions'
		#can :access, :'api/groups'
		#can :access, :'api/statistics'
		#can :access, :'api/collections'
		#can :access, :'api'



 end
	

