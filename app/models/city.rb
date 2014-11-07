# coding: utf-8
# == Schema Information
#
# Table name: cities
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  province_id :integer
#  level       :integer
#  zip_code    :string(255)
#  pinyin      :string(255)
#  pinyin_abbr :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#
# Indexes
#
#  index_cities_on_level        (level)
#  index_cities_on_name         (name)
#  index_cities_on_pinyin       (pinyin)
#  index_cities_on_pinyin_abbr  (pinyin_abbr)
#  index_cities_on_province_id  (province_id)
#  index_cities_on_zip_code     (zip_code)
#

# TODO encoding  equal? coding  ?????????????????????
class City < ActiveRecord::Base
  if Rails.version < '4.0'
    attr_accessible :name, :province_id, :level, :zip_code, :pinyin, :pinyin_abbr
  end

  belongs_to :province
  has_many :districts, dependent: :destroy

  def short_name
    @short_name ||= name.gsub(/市|自治州|地区|特别行政区/,'')
  end

  def brothers
    @brothers ||= City.where("province_id = #{province_id}")
  end

end
