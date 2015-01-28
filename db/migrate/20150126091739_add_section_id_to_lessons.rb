class AddSectionIdToLessons < ActiveRecord::Migration
  def change
    add_column :lessons, :section_id, :integer
  end
end
