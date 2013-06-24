class Question < ActiveRecord::Base
  belongs_to :collection
  belongs_to :game_user
  has_many :answers
  has_many :game_user_answers
  has_many :game_users, :through => :game_user_answers
  accepts_nested_attributes_for :answers
  
  def self.get_question_data(params)
    if params.has_key?(:question_id)
      question = Question.find(params[:question_id])
      unless question.nil?
        question
      end
    elsif params.has_key?(:random_number) && params.has_key?(:collection_id)
      questions = Question.get_random_questions(params[:random_number].to_i, params[:collection_id])
    end
  end
  
  def self.get_random_questions(number, collection_id)
    questions = Question.where(:collection_id => collection_id)
    if number > questions.length
      questions
    else
      questions.order('RAND()').limit(number)
    end
  end
  
  def self.submit_question_answer(params)
    question = Question.find_by_id(params[:question_id])
    answer = Answer.find_by_id(params[:answer_id])
    token = AuthToken.find_by_token(params[:token])
    
    if question.nil?
      return Error.create(:error_type_id => '1', :name => 'Answer Submission Failure', :description => 'The question you submitted the answer for does not exist.')
    elsif answer.nil?
      return Error.create(:error_type_id => '1', :name => 'Answer Submission Failure', :description => 'The answer you submitted for the question does not exist.')
    else
      return GameUserAnswer.create(:game_user_id => token.game_user_id, :answer_id => answer.id, :question_id => question.id)
    end
    
  end
  
  def self.submit_question(params)
    if params[:question].has_key?(:id)
      question = Question.find_by_id(params[:question][:id])
      if question.update_attributes(params[:question])
        question
      else
        Error.create(:error_type_id => 7, :name => 'Question Update Failure', :description => 'That question was not updated successfully')
      end
    else
      question = Question.new(params[:question])
      if question.save
        question.to_xml(:include => [:answers])
      else
        Error.create(:error_type_id => 7, :name => 'Question Creation Failure', :description => 'That question was not created successfully')
      end
    end
  end

  def self.remove_question(params)
    question = Question.find_by_id(params[:question_id])
    question.destroy
    question
  end
end
