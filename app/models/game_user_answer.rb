class GameUserAnswer < ActiveRecord::Base
  belongs_to :game_user
  belongs_to :answer
  belongs_to :question
end
