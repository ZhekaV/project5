redis_configs = {
  url:        Rails.application.secrets.redis['url'],
  namespace:  Rails.application.secrets.redis['namespace']
}

Sidekiq.configure_server do |config|
  config.redis = redis_configs
end
Sidekiq.configure_client do |config|
  config.redis = redis_configs
end

Rails.application.config.active_job.queue_adapter = :sidekiq
