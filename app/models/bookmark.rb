# == Schema Information
#
# Table name: bookmarks
#
#  id                :integer          not null, primary key
#  user_id           :integer
#  bookmarkable_id   :integer
#  bookmarkable_type :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#

class Bookmark < ActiveRecord::Base
    belongs_to :user
    belongs_to :bookmarkable, :polymorphic => true
end
