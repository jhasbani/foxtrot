class CreateVisits < ActiveRecord::Migration
  def change
    create_table :visits do |t|
      t.references :site, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.boolean :visited
      t.boolean :wished

      t.timestamps null: false
    end
  end
end
