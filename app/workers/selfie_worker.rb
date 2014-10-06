class SelfieWorker
  include Sidekiq::Worker
  sidekiq_options queue: :high_priority, retry: 3, backtrace: true

  def perform(requested_selfie="brooklyn bridge")
    puts "Received job for #{requested_selfie}"
    `selfie "#{requested_selfie}"`
  end
end
