class CreateBookmarks < ActiveRecord::Migration
  def change
    create_table :bookmarks do |t|
      t.integer :user_id
      t.references :bookmarkable, :polymorphic => true

      t.timestamps
    end
  end
end
