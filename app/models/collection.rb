class Collection < ActiveRecord::Base
  belongs_to :group
  has_many :questions
  
  validates_presence_of :description

  attr_accessible :id
  
      
  def self.create_collection(game_user, group, description)
    collection = Collection.create(:description => description, :creator_id => game_user.id)
    group.collections << collection
    collection
  end
  
  def self.edit_collection(group, description, collection_id)
    collection = Collection.find_by_id(collection_id)
    if collection.nil?
      Error.create(:error_type_id => '8', :name => 'Collection deletion failure.', :description => 'That collection does not exist.')
    else      
      collection.description = description
      collection.save
      collection
    end
  end
  
  def self.remove_collection(group, collection_id)
    collection = Collection.find_by_id(collection_id)
    if collection.nil?
      Error.create(:error_type_id => '8', :name => 'Collection deletion failure.', :description => 'That collection does not exist.')
    else
      collection.destroy
      collection
    end
  end

  def copy_collection_data(collection_id, group_id, creator_id)
    old_col = Collection.find_by_id(collection_id)
    new_col = Collection.new(old_col.attributes.merge(:collection_id => collection.id.last + 1,  :creator_id => creator_id, :group_id => group_id))
    new_col
  end
   
end
