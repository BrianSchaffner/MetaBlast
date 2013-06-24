class AddCollectionIdToQuestions < ActiveRecord::Migration
  def self.up
    add_column :questions, :collection_id, :integer
  end

  def self.down
    remove_column :questions, :collection_id
  end
end
