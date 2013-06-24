class GroupAbility
  include CanCan::Ability
  # TO-DO: DO NOT AUTHORIZE IF THEY ALREADY HAVE A PENDING GUG
  def initialize(user, group)
    if user.admin_in_group?(group)      
      can [:read, :update], Group,                :id => group.id
      can :invite_to, Group,                      :id => group.id
      can :accept_member, GameUserGroup,          :group_id => group.id
      can :create_collection, Group,              :id => group.id
      can :join, Group do |group|
        user.game_user_groups.where(:group_id => group.id).nil?
      end
    elsif user.owner_in_group?(group)
      can :manage, Group
      can :invite_to, Group,                      :id => group.id
      can :accept_member, GameUserGroup,          :group_id => group.id
      can :create_collection, Group,              :id => group.id
      can :join, Group do |group|
        user.game_user_groups.where(:group_id => group.id).nil?
      end
    else
      can :read, Group do |group|
        gug_state = user.game_user_groups.where(:group_id => group.id).first.state
        if gug_state == 'accepted'
          true
        else
          false
        end
      end
      
      can :join, Group do |group|
        user.game_user_groups.where(:group_id => group.id).nil?
      end
    end
  end
  
end
