# encoding: utf-8
class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders, :comment => '订单' do |t|
      t.integer :quantity, :null => false, :default => 1, :comment => '数量'
      t.decimal :price, :null => false, :default => 0, :scale => 2, :precision => 16, :comment => '价格(元)'
      t.decimal :discount, :null => false, :default => 0, :comment => '打折后的价格(元)'
      t.string :trade_no, :null => false, :comment => '交易号'

      t.timestamps
    end
  end
end
