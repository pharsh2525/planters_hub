ActiveAdmin.register Category do
  permit_params :category_name

  index do
    selectable_column
    id_column
    column :category_name
    actions
  end

  filter :category_name

  show do |category|
    attributes_table do
      row :category_name
      row :created_at
      row :updated_at
      # If you want to show plants associated with the category
      row "Plants" do |c|
        ul do
          c.plants.each do |plant|
            li link_to(plant.name, admin_plant_path(plant))
          end
        end
      end
    end
    active_admin_comments
  end

  form do |f|
    f.inputs do
      f.input :category_name
    end
    f.actions
  end
end
