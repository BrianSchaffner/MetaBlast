class Answer < ActiveRecord::Base
  belongs_to :question
  has_many :game_user_answers
  has_many :game_users, :through => :game_user_answers
end
