class CreateAgreements < ActiveRecord::Migration
  def change
    create_table :agreements do |t|
      t.text :detail

      t.timestamps
    end
  end
end
