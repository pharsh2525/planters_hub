# db/migrate/[timestamp]_drop_pages.rb

class DropPages < ActiveRecord::Migration[6.1] # make sure to use the correct version for your app
  def up
    drop_table :pages
  end

  def down
    create_table :pages do |t|
      t.string :title
      t.text :content

      t.timestamps
    end
  end
end
