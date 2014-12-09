class AddIntroduceToTechears < ActiveRecord::Migration
  def change
      add_column :teachers, :introduce, :string
  end
end
