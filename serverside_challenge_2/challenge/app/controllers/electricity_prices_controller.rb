class ElectricityPricesController < ApplicationController
  def index
    ampere = Integer(index_params[:ampere])
    usage = Integer(index_params[:usage])
    plans = ElectricityPriceCalculateService.new(ampere, usage).calc
    render json: plans
  end

  private

  def index_params
    params.permit(:ampere, :usage)
  end
end
