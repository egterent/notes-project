class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  process resize_to_limit: [80, 80]

  # Creates different versions of uploaded files:
  version :thumb do
    process resize_to_fit: [50, 50]
  end

  if Rails.env.production?
    storage :fog
  else
    storage :file
  end

  # The white list of extensions which are allowed to be uploaded.
  def extension_whitelist
    %w[jpg jpeg gif png]
  end
end
