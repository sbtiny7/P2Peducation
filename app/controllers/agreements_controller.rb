class AgreementsController < ApplicationController
  before_action :set_agreement, only: [:show, :edit, :update, :destroy]

  def index
    @agreements = Agreement.all
    respond_with(@agreements)
  end

  def show
    respond_with(@agreement)
  end

  def new
    @agreement = Agreement.new
    respond_with(@agreement)
  end

  def edit
  end

  def create
    @agreement = Agreement.new(agreement_params)
    @agreement.save
    respond_with(@agreement)
  end

  def update
    @agreement.update(agreement_params)
    respond_with(@agreement)
  end

  def destroy
    @agreement.destroy
    respond_with(@agreement)
  end

  private
    def set_agreement
      @agreement = Agreement.find(params[:id])
    end

    def agreement_params
      params.require(:agreement).permit(:detail)
    end
end
