class PopulateSites < ActiveRecord::Migration
  def change
    doc = File.open(Rails.root + "vendor/whc-en.xml") { |f| Nokogiri::Slop(f.read) }
    doc.query.row.each do |row|
      site = Site.new
      site.site_id = row.id_number.text
      site.name = row.site.text
      site.url = row.http_url.text
      site.latitude = row.latitude.text
      site.longitude = row.longitude.text
      site.region = row.region.text
      site.save!
    end
  end
end
