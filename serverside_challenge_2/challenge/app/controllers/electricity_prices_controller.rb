class ElectricityPricesController < ApplicationController
  ALLOWED_AMPERES = [10, 15, 20, 30, 40, 50, 60]

  def index
    ampere = Integer(index_params[:ampere])
    usage = Integer(index_params[:usage])

    unless ALLOWED_AMPERES.include?(ampere)
      render json: { error: "契約アンペア数は #{ALLOWED_AMPERES.join('/')} のいずれかを指定してください" }, status: :bad_request
      return
    end

    if usage < 0
      render json: { error: '使用量は 0 以上の整数を指定してください' }, status: :bad_request
      return
    end

    plans = ElectricityPriceCalculateService.new(ampere, usage).calc
    render json: plans
  rescue ArgumentError
    render json: { error: 'アンペア数と使用量は整数で指定してください' }, status: :bad_request
  end

  private

  def index_params
    params.permit(:ampere, :usage)
  end
end
