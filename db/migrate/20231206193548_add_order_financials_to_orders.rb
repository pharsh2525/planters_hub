class AddOrderFinancialsToOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :subtotal, :decimal, precision: 15, scale: 2
    add_column :orders, :gst_rate, :decimal, precision: 5, scale: 2
    add_column :orders, :pst_rate, :decimal, precision: 5, scale: 2
    add_column :orders, :hst_rate, :decimal, precision: 5, scale: 2
    add_column :orders, :total, :decimal, precision: 15, scale: 2
  end
end
