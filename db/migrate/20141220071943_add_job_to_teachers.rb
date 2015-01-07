class AddJobToTeachers < ActiveRecord::Migration
  def change
    add_column :teachers, :job, :string
  end
end
