class User < ActiveRecord::Base

  has_many :visits do
    def for_map(map)
      where(site_id: map.sites.ids)
    end
  end

  def display_name
    name.sub(/(.* [A-Za-z])[A-Za-z]*/, '\1')
  end

	# Callback from omniauth when authenticated
  def self.from_omniauth(auth)
		# find or create user given authentication details
		p auth.info
		p auth.credentials
    where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.save!
    end
  end
end
