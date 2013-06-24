class QuestionsController < ApplicationController
	load_and_authorize_resource
	
	before_filter :get_collection, :only => [:new, :create]
	
	respond_to :html
	
  def index
		redirect_to root_path
  end

  def show

  end

  def new
		4.times{@question.answers.build}
  end

  def edit
		if @question.answers.empty?
			4.times{@question.answers.build}
		end
  end

  def create
		@question.game_user_id = current_game_user.id
		@question.collection = @collection
		
		if @question.save
			flash[:notice] = 'Question was successfully created.'
		end
		
		respond_with(@question, :location => collection_path(@collection))
  end

  def update
		@collection = @question.collection
		
		if @question.update_attributes(params[:question])
			flash[:notice] = 'Question was successfully updated.'
		end
		
		respond_with(@question, :location => collection_path(@collection))
  end

  def destroy
		if @question.destroy
			flash[:notice] = 'Question succesfully removed.'
		end
		
		respond_with(@question, :location => collection_path(@question.collection))
  end
	
	private
	
	def get_collection
		@collection = Collection.find(params[:collection_id])
		# Using this instead of a load_and_authorize_resource (LAAR) :collection, :through => :collection
		# because it is broken in Rails 3.1
		authorize! :access, @collection
	end
	
end
