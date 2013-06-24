class CreatePatchNotes < ActiveRecord::Migration
  def change
    create_table :patch_notes do |t|
      t.string :version
      t.text :notes

      t.timestamps
    end
  end
end
