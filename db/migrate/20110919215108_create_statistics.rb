class CreateStatistics < ActiveRecord::Migration
  def self.up
    create_table :statistics do |t|
      t.integer :game_user_id
      t.integer :level_id

      t.timestamps
    end
  end

  def self.down
    drop_table :statistics
  end
end
