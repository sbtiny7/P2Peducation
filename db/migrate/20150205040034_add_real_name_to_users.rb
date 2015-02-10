class AddRealNameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :real_name, :string, comment: "真实姓名"
  end
end
