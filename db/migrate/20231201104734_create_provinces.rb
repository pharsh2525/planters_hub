class CreateProvinces < ActiveRecord::Migration[7.0]
  def change
    create_table :provinces do |t|
      t.string :name
      t.decimal :PST
      t.decimal :GST
      t.decimal :HST

      t.timestamps
    end
  end
end
