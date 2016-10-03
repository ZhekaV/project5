Sidekiq.configure_server do |config|
  config.redis = {
    url:        "redis://#{Rails.application.secrets.redis['hostname']}:#{Rails.application.secrets.redis['port']}/0",
    namespace:  'project5'
  }
  config.server_middleware do |chain|
    chain.add Sidekiq::Middleware::Server::RetryJobs, max_retries: 0
  end
end

Sidekiq.configure_client do |config|
  config.redis = {
    url:        "redis://#{Rails.application.secrets.redis['hostname']}:#{Rails.application.secrets.redis['port']}/0",
    namespace:  'project5'
  }
end
