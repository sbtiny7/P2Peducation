class Admin::AlipayController <  ApplicationController
  #not forget before_action and layout
  layout :set_layout


  def payall
    @cash=Cash.all
  end

  private
  def set_layout
    return 'admin'
  end

end
