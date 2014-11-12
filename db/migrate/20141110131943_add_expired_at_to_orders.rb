class AddExpiredAtToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :expired_at, :datetime, :comment => '订单作废时间'
  end
end
