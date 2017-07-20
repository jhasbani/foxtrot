class AddMapToSite < ActiveRecord::Migration
  def change
    add_reference :sites, :map, index: true, foreign_key: true
  end
end
