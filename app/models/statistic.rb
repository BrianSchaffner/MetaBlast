class Statistic < ActiveRecord::Base
  has_many :detailed_statistics
	belongs_to :game_user
  accepts_nested_attributes_for :detailed_statistics
  
  def self.begin_session(game_user, params)
    stat = Statistic.create(params[:statistic])
    game_user.statistics << stat
    stat
  end
  
end
