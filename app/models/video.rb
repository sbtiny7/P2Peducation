# == Schema Information
#
# Table name: videos
#
#  id             :integer          not null, primary key
#  stream_name    :string(255)
#  videoable_id   :integer
#  videoable_type :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#

class Video < ActiveRecord::Base
    belongs_to :videoable, :polymorphic => true

    def url(type)
    # case type.to_s
    # end
    end

    def faye_channel
        "/channel/video/#{stream_name}"
    end
    def self.faye_channel
        "/channel/video/*"
    end
end
