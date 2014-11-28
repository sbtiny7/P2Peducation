class AddLivingToCourses < ActiveRecord::Migration
  def change
      add_column :courses, :living, :boolean
  end
end
