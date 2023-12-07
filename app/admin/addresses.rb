ActiveAdmin.register Address do
  permit_params :street_address, :city, :postal_code, :user_id, :province_id # add other fields as needed

  index do
    selectable_column
    id_column
    column :address
    column :city
    column :postal_code
    column :user
    column :province
    actions
  end

  filter :city
  filter :postal_code
  filter :user
  filter :province

  form do |f|
    f.inputs do
      f.input :address
      f.input :city
      f.input :postal_code
      f.input :user, as: :select, collection: User.all
      f.input :province, as: :select, collection: Province.all
      # Add other inputs
    end
    f.actions
  end

  show do |address|
    attributes_table do
      row :street_address
      row :city
      row :postal_code
      row :user
      row :province
      # Add other rows
    end
    active_admin_comments
  end
end
