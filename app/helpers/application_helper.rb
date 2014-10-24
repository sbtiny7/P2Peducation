module ApplicationHelper
  def double(i)
    i.to_s.rjust 2, "0"
  end
end
