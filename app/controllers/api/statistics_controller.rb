class Api::StatisticsController < ApiController
	# See API Documentation on Basecamp
  before_filter :verify_token
  
  def add
    render :xml => Statistic.begin_session(@game_user, params).to_xml(:include => :detailed_statistics)
  end
  
  private
  
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
