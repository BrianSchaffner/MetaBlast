class CreateAchievements < ActiveRecord::Migration
  def up
    create_table :achievements do |t|
    	t.string :name
    	t.string :description
    	t.integer :game_user_id
    	t.integer :level_id
      
      t.timestamps
    end 
  end
  
  def down
  	remove_column :name
  	remove column :description
  	remove_column :game_user_id
  	remove_column :level_i
  end	
end
