class CreateTeachers < ActiveRecord::Migration
  def change
    create_table :teachers do |t|
      t.integer :user_id
      t.string  :name
      t.boolean :sex
      t.string  :phone
      t.string  :email
      t.string  :organ_name
      t.text    :organ_detail
      t.integer :agreement_id

      t.timestamps
    end
  end
end
