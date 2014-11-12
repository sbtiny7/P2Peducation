class AddPayUrlToOrders < ActiveRecord::Migration
  def change
      add_column :orders, :full_pay_path, :text
  end
end
