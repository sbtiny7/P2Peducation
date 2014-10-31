# encoding: utf-8

class AvatarUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  # storage :file
  # storage :fog
  storage :azure

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
    User::DEFAULT_AVATAR_PATH
  end

  version :crop do
    process :crop
    process :resize_to_fill => [200, 200]
  end

  version :thumb do
    process :crop
    process :resize_to_fill => [32, 32]
  end
  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process :resize_to_fit => [50, 50]
  # end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg gif png)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  def filename
    "#{model.class.to_s.underscore}_#{mounted_as}_#{model.id}.#{file.extension}" if original_filename
  end

  def crop
    Rails.logger.info("before the avatar crop, avatar_x: #{model.avatar_x} ==================================")
    if model.avatar_x.present?
      Rails.logger.info("in the avatar crop ==================================")
      manipulate! do |img|
        arr = [model.avatar_x, model.avatar_y, model.avatar_w, model.avatar_h].map do |a|
          if [img.columns, img.rows].max < 400
            a.to_i
          else
            a.to_i * [img.columns, img.rows].max / User::AVATAR_PREVIWE_SIZE
          end
        end
        img.crop "#{arr[2]}x#{arr[3]}+#{arr[0]}+#{arr[1]}"
        img
      end
    end
  end
end
