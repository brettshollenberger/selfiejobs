class SelfieWorker
  include Sidekiq::Worker
  sidekiq_options queue: :high_priority, retry: 3, backtrace: true

  def perform(requested_selfie="brooklyn bridge")
    `selfie "#{requested_selfie}"`
    upload_to_s3
  end

private
  def upload_to_s3
    object.write(Pathname.new("final.png"))
  end

  def object
    bucket.objects["final.png"]
  end

  def bucket
    aws.buckets["selfiegram"]
  end

  def aws
    @aws ||= AWS::S3.new :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
                         :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY'],
                         :region => 'us-west-2'
  end
end
