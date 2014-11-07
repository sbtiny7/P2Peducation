# encoding: utf-8
# == Schema Information
#
# Table name: provinces
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  pinyin      :string(255)
#  pinyin_abbr :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#
# Indexes
#
#  index_provinces_on_name         (name)
#  index_provinces_on_pinyin       (pinyin)
#  index_provinces_on_pinyin_abbr  (pinyin_abbr)
#

class Province < ActiveRecord::Base
  if Rails.version < '4.0'
    attr_accessible :name, :pinyin, :pinyin_abbr
  end

  has_many :cities, dependent: :destroy
  has_many :districts, through: :cities
end
