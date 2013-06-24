class CreateQuestions < ActiveRecord::Migration
  def self.up
    create_table :questions do |t|
      t.float :x_pos
      t.float :y_pos
      t.float :z_pos
      t.integer :game_user_id
      t.text :content
      t.text :feedback

      t.timestamps
    end
  end

  def self.down
    drop_table :questions
  end
end
