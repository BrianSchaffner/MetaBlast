Metablast::Application.routes.draw do
  resources :carts

  devise_for :game_users
	
	resources :answers

  resources :collections do
		resources :questions
	end

  resources :questions
	
	namespace :groups do
		get 'find'
		post 'search'
	end
	
  resources :groups do
		get 'members'
		post 'remove_member'
		post 'make_admin'
		post 'remove_admin'
		get 'invite'
		post 'send_invite'
		post 'accept_invite'
		post 'reject_invite'
		post 'join'
		post 'leave'
		post 'accept_member'
		post 'reject_member'
		
		resources :collections
	end

	root :to => 'dashboard#home'
	
  
  namespace :api do
		post 'patch_notes'
		
    namespace :groups do
      post 'get_users'# Change to GET pending Mark's change
      post 'get_active_users'# Change to GET pending Mark's change
      post 'get_pending_users'# Change to GET pending Mark's change
      post 'get_by_user' # Change  to GET pending Mark's change
      post 'join'#
      post 'invite'#
      post 'accept_invite' #
      post 'reject_invite' #
      post 'accept_member' #
      post 'reject_member' #
      post 'create' #
      post 'remove' #
      post 'make_admin' 
      post 'remove_member'#
    end
    
    namespace :game_users do
      post 'login'#
      post 'logout'#
      post 'sign_up'#
      post 'get_groups' # Change to GET pending Mark's change
      get 'get_pending_groups'#
      get 'get_active_groups'#
      get 'get_questions'#
      get 'get_groups_by_user'
      get 'add_statistic'
    end
    
    namespace :statistics do
      post 'add'
    end
    
    namespace :questions do
      post 'get_data'# Change to GET pending Mark's change
      post 'submit_answer'#
      post 'submit'#
      post 'remove'
    end
    
    namespace :collections do
      post 'create'#
      post 'remove'#
      post 'edit'#
    end

  end
  
end
