# app/admin/pages.rb
ActiveAdmin.register Page do
  permit_params :title, :content, :slug

  index do
    selectable_column
    id_column
    column :title
    column :slug
    actions
  end

  form do |f|
    f.inputs do
      f.input :title
      f.input :slug
      f.input :content, as: :text
    end
    f.actions
  end

  show do
    attributes_table do
      row :title
      row :slug
      row :content do |page|
        page.content.html_safe
      end
    end
  end
end
