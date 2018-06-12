CarrierWave.configure do |config|
  unless Rails.env.development? || Rails.env.test?
    config.fog_provider = 'fog/aws'
    config.fog_credentials = {
      provider: 'AWS',
      aws_access_key_id: ENV["AWS_ACCESS_KEY_ID"],
      aws_secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"],
      region: ENV["AWS_REGION"]
    }

    config.storage = :fog
    config.asset_host = 'https://s3.amazonaws.com/su-mire'
    config.fog_directory = ENV["AWS_BUCKET_NAME"],
    config.cache_storage = :fog
  end
end
