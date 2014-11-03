# encoding: utf-8
class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders, :comment => '订单' do |t|
      t.integer :user_id, :null => false, :comment => '订单所属用户id'
      t.integer :goods_id,:null => false, :comment => '商品id'
      t.integer :quantity, :null => false, :default => 1, :comment => '数量'
      t.decimal :price, :null => false, :default => 0, :scale => 2, :precision => 16, :comment => '价格(元)'
      t.decimal :discount, :null => false, :default => 0, :scale => 2, :precision => 16, :comment => '打折后的价格(元)'
      t.string :trade_no, :null => false, :comment => '交易号'
      t.string :status, :null => false, :default => 'pendding', :comment => '订单状态'
      t.timestamps
    end

    add_index :orders, :trade_no, unique: true
    add_index :orders, :goods_id, unique: true
  end
end
