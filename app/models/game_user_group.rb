class GameUserGroup < ActiveRecord::Base
  belongs_to :game_user
  belongs_to :group
  belongs_to :game_role
	
	validates_uniqueness_of :game_user_id, :scope => :group_id
  
  state_machine :initial => :new do
    
    event :created_group do 
      transition :new => :owner
    end
    
    event :invite_to_group do
      transition :new => :invite_pending
    end
    
    event :join_group do
      transition :new => :pending_approval
    end
    
    event :accept_invite do
      transition :invite_pending => :accepted
    end
    
    event :reject_invite do
      transition :invite_pending => :rejected
    end
    
    event :accept_member do
      transition :pending_approval => :accepted
    end
    
    event :reject_member do
      transition :pending_approval => :rejected
    end
    
    event :remove_member do
      transition :accepted => :rejected
    end
    
  end
end
