class Admin::AlipayController <  ApplicationController
  #not forget before_action and layout
  layout :set_layout


  def payall
    @cash=Cash.all
  end


  def edit
    @cash=Cash.find(params[:id])
    @cash.finished=true;
    @cash.save
    redirect_to admin_alipay_payall_path
  end


  private
  def set_layout
    return 'admin'
  end

end
