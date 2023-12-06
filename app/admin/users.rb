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
      panel "Actions" do
        span link_to "Send Reset Password Instructions", send_reset_password_instructions_admin_user_path(user), method: :post, data: { confirm: "Are you sure you want to send reset password instructions to this user?" }
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
