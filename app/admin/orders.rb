# app/admin/orders.rb
ActiveAdmin.register Order do
  permit_params :status, :user_id, :address_id, :payment_confirmation, #... any other fields

  index do
    selectable_column
    id_column
    column :status
    column :user
    column :address
    column :payment_confirmation
    #... any other columns you want to display
    actions
  end

  filter :user
  filter :status
  # ... any other filters you need

  form do |f|
    f.inputs do
      f.input :user, as: :select, collection: User.all
      f.input :status
      f.input :address, as: :select, collection: Address.all
      f.input :payment_confirmation
      # ... any other inputs
    end
    f.actions
  end

  # Customize the show page
  show do
    attributes_table do
      row :status
      row :user
      row :address
      row :payment_confirmation
      # ... any other rows
      panel "Order Items" do
        table_for order.order_items do
          column :plant
          column :quantity
          column :unit_price
          # ... other order item attributes ...
          column "Actions" do |order_item|
            links = []
            links << link_to("View", admin_order_order_item_path(order, order_item))
            links << link_to("Edit", edit_admin_order_order_item_path(order, order_item))
            safe_join(links, " | ")
          end
        end
      end
    end
    active_admin_comments
  end

  # ... any controller customizations

end
