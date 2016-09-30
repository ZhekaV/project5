class SidekiqJob < ActiveJob::Base
  self.queue_adapter = :sidekiq
end
