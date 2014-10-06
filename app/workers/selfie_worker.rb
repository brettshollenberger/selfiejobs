class SelfieWorker
  include Sidekiq::Worker
  sidekiq_options queue: :high_priority, retry: 3, backtrace: true

  def perform(requested_selfie="brooklyn bridge")
    `selfie "#{requested_selfie}"`
  end
end
