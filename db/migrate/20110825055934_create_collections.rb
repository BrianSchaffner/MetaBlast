class CreateCollections < ActiveRecord::Migration
  def self.up
    create_table :collections do |t|
      t.text :description
      t.integer :group_id
      t.integer :creator_id

      t.timestamps
    end
  end

  def self.down
    drop_table :collections
  end
end
