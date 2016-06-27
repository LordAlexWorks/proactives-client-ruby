class Proactives::Config
  attr_reader :config

  def initialize(config = {})
    @config = config
  end

  def api_version
    config[:api_version] || 'v1'
  end

  def api_url
    config[:api_url] || ENV['PROACTIVES_API_URL']
  end

  def app_id
    config[:app_id] || ENV['PROACTIVES_APP_ID']
  end

  def secret
    config[:secret] || ENV['PROACTIVES_SECRET']
  end

  def find_user_api_url
    config[:find_user_api_url] || "#{api_url}/#{api_version}/me"
  end

  def create_user_api_url
    config[:create_user_api_url] || "#{api_url}/#{api_version}/users"
  end

  def update_user_api_url(id)
    config[:update_user_api_url] || "#{api_url}/#{api_version}/users/#{id}"
  end

  def generate_new_password_email_api_url
    config[:generate_new_password_email_api_url] ||
      "#{api_url}/#{api_version}/users/password"
  end

  def site_url
    config[:site_url] || ENV['PROACTIVES_SITE']
  end

  def app_access_token
    config[:app_access_token] || ENV['PROACTIVES_APP_ACCESS_TOKEN']
  end
end
