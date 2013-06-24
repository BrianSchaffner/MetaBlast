class CreateDetailedStatistics < ActiveRecord::Migration
  def self.up
    create_table :detailed_statistics do |t|
      t.integer :statistic_id
      t.string :key
      t.string :value

      t.timestamps
    end
  end

  def self.down
    drop_table :detailed_statistics
  end
end
