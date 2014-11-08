module ApplicationHelper
  def double(i)
    i.to_s.rjust 2, "0"
  end

  def short_format(date_time)
    return unless date_time.respond_to? :strftime
    date_time.strftime Time::DATE_FORMATS[:short]
  end

  def token_field
    hidden_field_tag(:__token__, (@__token__ ||= (session[:__token__] =
      Digest::MD5.hexdigest((Time.now.to_i + rand(0xffffff)).to_s)[0..39])))
  end

  def city_region(object, methods, options ={}, html_options={})
    return unless object.present?
    if Array === methods
      # 数组参数
    else
      # 一个参数

    end
  end

end
