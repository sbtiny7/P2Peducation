class Admin::AgreementsController < ApplicationController
  before_action :set_agreement, only: [:show, :edit, :update, :destroy]

  def index
    @agreements = Agreement.all
    respond_with(:admin, @agreements)
  end

  def show
    respond_with(:admin, @agreement)
  end

  def new
    @agreement = Agreement.new
    respond_with(:admin, @agreement)
  end

  def edit
  end

  def create
    @agreement = Agreement.new(agreement_params)
    @agreement.save
    respond_with(:admin, @agreement)
  end

  def update
    @agreement.update(agreement_params)
    respond_with(:admin, @agreement)
  end

  def destroy
    @agreement.destroy
    respond_with(:admin, @agreement)
  end

  private
    def set_agreement
      @agreement = Agreement.find(params[:id])
    end

    def agreement_params
      params.require(:agreement).permit(:detail)
    end
end
