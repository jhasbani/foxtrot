class CreateUnescoMap < ActiveRecord::Migration
  def change
		m = Map.create!(title: 'UNESCO World Heritage Sites')
		Site.all.update_all(map_id: m.id)
  end
end
