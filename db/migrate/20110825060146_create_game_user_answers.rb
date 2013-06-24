class CreateGameUserAnswers < ActiveRecord::Migration
  def self.up
    create_table :game_user_answers do |t|
      t.integer :game_user_id
      t.integer :answer_id
      t.integer :question_id

      t.timestamps
    end
  end

  def self.down
    drop_table :game_user_answers
  end
end
