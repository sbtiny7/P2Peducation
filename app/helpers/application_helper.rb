module ApplicationHelper
  def double(i)
    i.to_s.rjust 2, "0"
  end

  def short_format(date_time)
  	return unless date_time.respond_to? :strftime
  	date_time.strftime Time::DATE_FORMATS[:short]
  end
end
