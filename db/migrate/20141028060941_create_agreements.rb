class CreateAgreements < ActiveRecord::Migration
  def change
    create_table :agreements do |t|
      t.text :detail

      t.timestamps
    end
    Agreement.create(:detail => "test")
  end
end
