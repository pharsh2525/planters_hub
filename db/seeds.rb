require 'csv'
require 'open-uri'
require 'mini_magick'

Plant.delete_all
Category.delete_all

ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence WHERE name='categories';")
ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence WHERE name='plants';")
ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence WHERE name='active_storage_attachments';")
ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence WHERE name='active_storage_blobs';")
ActiveStorage::Attachment.all.each { |attachment| attachment.purge }

fileName = Rails.root.join('db/Plants.csv')

puts "Loading Plants from the CSV file: #{fileName}"

csv_data = File.read(fileName)

plants = CSV.parse(csv_data, headers: true, encoding: 'utf-8')

def process_image(image_src_string, plant)
  image_src = image_src_string.split(',').select { |src| src.include?('1080w') }.first
  image_url = image_src.present? ? "https:#{image_src.split(' ').first.strip}" : nil
  return if image_url.blank?

  begin
    downloaded_image = URI.open(image_url)
    image = MiniMagick::Image.read(downloaded_image)
    image.format 'png' # Convert to PNG

    Tempfile.create(['plant', '.png']) do |file|
      image.write file.path
      file.rewind

      # Attach the converted image
      plant.images.attach(io: file, filename: "plant_#{plant.id}_#{File.basename(image_url)}", content_type: 'image/png')
      puts "Image converted and attached to #{plant.name}"
    end
  rescue OpenURI::HTTPError => e
    puts "Error downloading image for #{plant.name}: #{e.message}"
  end
end

plants.each do |pl|
  category = Category.find_or_create_by(category_name: pl['categories']) # Ensure the field name matches your CSV headers and model attributes

  plant = category.plants.create(
    name: pl['plant_name'],
    description: pl['plant_des'],
    price: pl['plant_price'].gsub('$', '').to_d
  )

  # Process primary image
  process_image(pl['plant_img-src'], plant) unless pl['plant_img-src'].blank?

  # Process additional image
  process_image(pl['additional_img-src'], plant) unless pl['additional_img-src'].blank?
end

puts "Imported #{Plant.count} plants"


