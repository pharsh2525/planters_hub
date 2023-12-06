ActiveAdmin.register Plant do
  permit_params :name, :description, :price, :category_id, images: []
  filter :name
  filter :price
  filter :category

  index do
    selectable_column
    id_column
    column :name
    column :price
    column :category
    column "Images" do |plant|
      plant.images.count
    end
    actions
  end

  show do |plant|
    attributes_table do
      row :name
      row :description
      row :price
      row :category
      row :images do
        ul do
          plant.images.each do |img|
            li do
              image_tag(img)
            end
          end
        end
      end
    end
    active_admin_comments
  end

  form html: { enctype: "multipart/form-data" } do |f|
    f.inputs do
      f.input :name
      f.input :description
      f.input :price
      f.input :category, as: :select, collection: Category.all.map { |c| [c.category_name, c.id] }
      f.input :images, as: :file, input_html: { multiple: true }
    end
    f.actions
  end

  controller do
    def create
      super do |format|
        redirect_to admin_plant_path(resource) and return if resource.valid?
      end
    end

    def update
      super do |format|
        if params[:plant][:images].present?
          resource.images.attach(params[:plant][:images])
          redirect_to admin_plant_path(resource) and return
        end
      end
    end
  end
end
