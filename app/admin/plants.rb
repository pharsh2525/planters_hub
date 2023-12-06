ActiveAdmin.register Plant do
  permit_params :name, :description, :price, :category_id, images: []
  filter :name
  filter :price
  filter :category_id, as: :select, collection: -> { Category.all.map { |c| [c.category_name, c.id] } }

  # app/admin/plants.rb
  member_action :delete_image, method: :delete do
    # Find the image and the plant
    plant = Plant.find(params[:plant_id])
    image = ActiveStorage::Attachment.find(params[:image_id])

    # Purge the image
    image.purge_later

    # Redirect back to the plant edit page
    redirect_back(fallback_location: edit_admin_plant_path(plant))
  end


  index do
    selectable_column
    id_column
    column :name
    column :price
    column "Category" do |plant|
      plant.category.category_name
    end
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
      row "Category" do |plant|
        plant.category.category_name
      end
      row :images do
        ul do
          plant.images.each do |img|
            li do
              image_tag(img) # Displaying a resized image
              # Add a delete button for each image
            end
          end
        end
      end
    end
    active_admin_comments
  end

  form html: { multipart: true } do |f|
    f.inputs 'Plant Details' do
      f.input :name
      f.input :description
      f.input :price
      f.input :category, as: :select, collection: Category.all.map { |c| [c.category_name, c.id] }
    end
    f.inputs 'Images' do
      f.object.images.each do |image| # make sure to use `image` here
        span image_tag(image.variant(resize_to_limit: [100, 100]))
        span link_to 'Remove image', admin_plant_delete_image_path(plant_id: f.object.id, image_id: image.id), method: :delete, data: { confirm: 'Are you sure?' }
      end
      f.input :images, as: :file, input_html: { multiple: true }
    end

    f.actions
  end


  # Adjust the controller to handle image deletion and avoid duplicate attachment
  controller do
    def update
      # You need to handle file uploads separately
      new_images = params[:plant].delete(:images)

      super do |success, failure|
        success.html do
          if new_images.present?
            new_images.each do |image|
              # Attach the new image if it's a file object and not already attached
              if image.is_a?(ActionDispatch::Http::UploadedFile)
                existing_filenames = resource.images.blobs.pluck(:filename)
                unless existing_filenames.include?(image.original_filename)
                  resource.images.attach(image)
                end
              end
            end
          end
          redirect_to admin_plant_path(resource) and return if resource.valid?
        end
        failure.html do
          render :edit
        end
      end
    end
  end

end
