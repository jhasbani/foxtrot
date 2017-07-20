class CreateMaps < ActiveRecord::Migration
  def change
    create_table :maps do |t|
      t.string :title
      t.string :description
      t.string :url
      t.datetime :created_at

      t.timestamps null: false
    end
  end
end
