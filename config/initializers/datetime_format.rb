# encoding: utf-8
Time::DATE_FORMATS.merge!(
  :serial => "%Y-%m-%d",
  :full => "%Y-%m-%d %H:%M:%S",
  :with_year => "%Y-%m-%d %H:%M",
  :short => "%m-%d %H:%M",
  :m_and_d => "%m-%d",
  :h_and_m => "%H:%M"
)
Date::DATE_FORMATS.merge!(
  :month_and_day => "%m-%d"
)