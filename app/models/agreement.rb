# == Schema Information
#
# Table name: agreements
#
#  id         :integer          not null, primary key
#  detail     :text
#  created_at :datetime
#  updated_at :datetime
#

class Agreement < ActiveRecord::Base
end
