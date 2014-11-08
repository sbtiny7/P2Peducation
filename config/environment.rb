# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!
Date::DATE_FORMATS[:default]    = "%Y-%m-%d"
Time::DATE_FORMATS[:default]    = "%Y-%m-%d %H:%M"
Time::DATE_FORMATS[:date]       = "%Y-%m-%d"
Time::DATE_FORMATS[:datetime]   = "%Y-%m-%d %H:%M:%S"
Time::DATE_FORMATS[:short_date] = "%b %d"
Time::DATE_FORMATS[:br]         = "%Y-%m-%d\n%H:%M"
Time::DATE_FORMATS[:time]       = "%H:%M"