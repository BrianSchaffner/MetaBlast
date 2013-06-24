class Api::QuestionsController < ApiController
	# See API Documentation on Basecamp
  before_filter :verify_token
  before_filter :verify_submit_answer_params, :only => [:submit_question_answer]
  
  def get_data
    render :xml => Question.get_question_data(params).to_xml(:include => [:answers, :game_user_answers])
  end
  
  def submit_answer
    render :xml => Question.submit_question_answer(params)
  end
  
  def submit
    render :xml => Question.submit_question(params)
  end
  
  def remove
    render :xml => Question.remove_question(params)
  end
  
  private
  
  def verify_submit_answer_params
    unless params.has_key?(:token) && params.has_key?(:question_id) && params.has_key?(:answer_id)
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
  
end