class SelfieWorker
  include Sidekiq::Worker
  sidekiq_options queue: :default, retry: 3, backtrace: true

  def perform(options={})
    `selfie -m '#{options["magic"]}' -u '#{options["user"]}' -o 'selfies'`
    upload_to_s3(options)
  end

private
  def pathify(string)
    string.split(" ").join("_").downcase
  end

  def upload_to_s3(options)
    object(options).write(Pathname.new("selfies/tmp/#{pathify(options["magic"])}/final.png"))
  end

  def object(options)
    bucket.objects["#{pathify(options["magic"])}/#{pathify(options["user"])}.png"]
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
