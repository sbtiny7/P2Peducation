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

require 'test_helper'

class VideoTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
