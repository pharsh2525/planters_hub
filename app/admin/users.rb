ActiveAdmin.register User do
  permit_params :email, :password, :password_confirmation, :first_name, :last_name, :is_admin

  member_action :send_reset_password_instructions, method: :post do
    user = User.find(params[:id])

    # Trigger Devise reset password method
    user.send_reset_password_instructions

    redirect_to admin_user_path(user), notice: "Password reset instructions have been sent to #{user.email}"
  end

  index do
    selectable_column
    id_column
    column :email
    column :first_name
    column :last_name
    column :is_admin
    actions
  end

  filter :email
  filter :first_name
  filter :last_name
  filter :is_admin

  form do |f|
    f.inputs do
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :first_name
      f.input :last_name
      f.input :is_admin
    end
    f.actions
  end

  show do
    attributes_table do
      row :email
      row :first_name
      row :last_name
      row :is_admin
      # Display other user attributes here
    end

    panel "Addresses" do
      table_for user.addresses do
        column :address
        column :city
        column :postal_code
        column :province do |address|
          address.province.name # Assuming province is associated with address and has a 'name' attribute
        end
        # ... other columns ...
        column "" do |address|
          links = []
          links << link_to("View", admin_address_path(address))
          links << link_to("Edit", edit_admin_address_path(address))
          safe_join(links, " | ")
        end
      end
    end

    panel "Orders" do
      table_for user.orders do
        column :id
        column :status
        column :total
        column :created_at
        # ... other columns ...
        column "" do |order|
          links = []
          links << link_to("View", admin_order_path(order))
          links << link_to("Edit", edit_admin_order_path(order))
          safe_join(links, " | ")
        end
      end
    end

    active_admin_comments
  end
  controller do
    def update
      if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
        params[:user].delete("password")
        params[:user].delete("password_confirmation")
      end
      super
    end
  end
end
