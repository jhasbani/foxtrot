class CreateSitesTable < ActiveRecord::Migration
  def change
    create_table :sites do |t|
      t.integer     :site_id
      t.string      :name
      t.decimal     :latitude
      t.decimal     :longitude
      t.string      :url
      t.string      :region
    end
  end
end
