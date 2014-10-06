# The redis server is set by ENV['REDIS_PROVIDER']. Default is redis://localhost:6379/0.
begin
  require 'sidekiq/middleware/i18n'

  Sidekiq.configure_server do |config|
    config.redis = { namespace: 'selfiegram' }
  end

  Sidekiq.configure_client do |config|
    config.redis = { namespace: 'selfiegram' }
  end

rescue Exception => e
  puts "Cannot initialize sidekiq with exception: #{e.inspect}."
end
