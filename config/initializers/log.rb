# We want to set up a custom logger which logs to STDOUT.
# Docker expects your application to log to STDOUT/STDERR and to be ran
# in the foreground.
Rails.application.config.log_level = :debug
# Rails.application.config.log_tags  = %i(subdomain uuid)
Rails.application.config.logger    = ActiveSupport::TaggedLogging.new(Logger.new(STDOUT))
