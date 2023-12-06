ActiveAdmin.register Province do
  permit_params :name, :PST, :GST, :HST

  index do
    selectable_column
    id_column
    column :name
    column :PST
    column :GST
    column :HST
    actions
  end

  filter :name
  filter :PST
  filter :GST
  filter :HST

  show do |province|
    attributes_table do
      row :name
      row :PST
      row :GST
      row :HST
    end
    active_admin_comments
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :PST
      f.input :GST
      f.input :HST
    end
    f.actions
  end
end
