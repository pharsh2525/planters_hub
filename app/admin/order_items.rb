# app/admin/order_items.rb
ActiveAdmin.register OrderItem do
  belongs_to :order
  permit_params :order_id, :plant_id, :quantity, :unit_price

  # Add index, filter, form, and show blocks similar to the Order resource above
end
