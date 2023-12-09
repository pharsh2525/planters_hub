# app/admin/orders.rb
ActiveAdmin.register Order do
  permit_params :status, :user_id, :address_id, :payment_confirmation, :subtotal, :gst_amount, :pst_amount, :hst_amount, :total

  index do
    selectable_column
    id_column
    column :status
    column :user
    column :address
    column :payment_confirmation
    column :total
    actions
  end

  filter :user
  filter :status

  form do |f|
    f.inputs do
      f.input :user, as: :select, collection: User.all.map { |u| [u.email, u.id] }
      f.input :status
      f.input :address, as: :select, collection: Address.all.map { |a| [a.full_address, a.id] }
      f.input :payment_confirmation
      f.input :subtotal
      f.input :gst_amount
      f.input :pst_amount
      f.input :hst_amount
      f.input :total
    end
    f.actions
  end

  show do
    attributes_table do
      row :status
      row :user
      row :address
      row :payment_confirmation
      row :subtotal
      row :gst_amount
      row :pst_amount
      row :hst_amount
      row :total
    end
    panel "Order Items" do
      table_for order.order_items do
        column :plant
        column :quantity
        column :unit_price
        column "Actions" do |order_item|
          links = []
          links << link_to("View", [:admin, order, order_item], class: 'member_link view_link')
          links << link_to("Edit", [:edit, :admin, order, order_item], class: 'member_link edit_link')
          safe_join(links, " | ")
        end
      end
    end
    active_admin_comments
  end
end
