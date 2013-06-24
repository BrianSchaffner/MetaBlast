class CollectionsController < ApplicationController
	load_and_authorize_resource
	
	before_filter :get_group, :only => [:new, :create, :index]
	
	respond_to :html
	
  def index
		@collections = @collections.where(:group_id => params[:group_id])
  end

  def show

  end

  def new

  end

  def edit
	
  end

  def create
		@collection.creator_id = current_game_user.id
		@collection.group = @group
		
		if @collection.save
			flash[:notice] = 'Collection was successfully created.'
		end
		
		respond_with(@collection)
  end

  def update
		if @collection.update_attributes(params[:collection])
			flash[:notice] = 'Collection was successfully updated.'
		end
		
		respond_with(@collection)
  end

  def destroy	
		if @collection.destroy
			flash[:notice] = 'Collection was successfully removed.'
		end
		
		respond_with(@collection, :location => group_collections_path(@collection.group))
  end
	
	private
	
	def get_group
		@group = Group.find(params[:group_id])
		# Using this instead of a load_and_authorize_resource (LAAR) :collection, :through => :group
		# because it is broken in Rails 3.1
		authorize! :access, @group
	end
	
end
