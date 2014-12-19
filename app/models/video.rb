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
#  tid            :string(255)
#  preview_addr   :string(255)
#  archived_addr  :string(255)
#

class Video < ActiveRecord::Base
  belongs_to :videoable, :polymorphic => true

  def url(type)
    # case type.to_s
    # end
  end
end
