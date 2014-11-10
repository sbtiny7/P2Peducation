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

  # 将city-region-fu中的城市排序
  def region_select2(object, methods, options = {}, html_options = {})
    options.symbolize_keys!
    html_options.symbolize_keys!
    append_region_class(html_options)

    if Array === methods
      output = ActiveSupport::SafeBuffer.new
      methods.each_with_index do |method, index|
        if klass = to_class(method)
          choices = index == 0 ? klass.select('id, name').order('id').collect { |p| [p.name, p.id] } : []
          next_method = methods.at(index + 1)
          set_html_options(object, method, html_options, next_method)

          output << content_tag(:div, select(object, method.to_s, choices, options.merge(prompt: options.delete("#{method}_prompt".to_sym)), html_options = html_options), class: "input region #{method.to_s}")
        else
          raise InvalidAttributeError
        end
      end
      output << js_for_region_ajax if methods.size > 1
      output
    else
      if klass = to_class(methods)
        content_tag(:div, select(object, methods, klass.select('id, name').order('id').collect { |p| [p.name, p.id] }, options = options, html_options = html_options), class: "input region #{methods.to_s}")
      else
        raise InvalidAttributeError
      end
    end
  end

  def get_label_class(type)
      case type
      when "ONLINE"
          "label label-danger"
      when "OFFLINE"
          "label label-primary"
      end
  end

  def left_content(count)
    if count < 10
      "只剩下#{count}名额"
    else
      "还有#{count}名额"
    end
  end
end
