class Site < ActiveRecord::Base
	belongs_to :map
  has_many :visits
end
