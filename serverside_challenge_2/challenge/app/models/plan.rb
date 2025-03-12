# frozen_string_literal: true

class Plan < ApplicationRecord
  belongs_to :provider
  has_many :electricity_charges_basic_rates, dependent: :destroy
  has_many :electricity_charges_usage_rates, dependent: :destroy

  validates :name, presence: true, uniqueness: { scope: :provider_id }

  def electricity_price(ampere, usage)
    # 基本料金、もしくは従量料金がなければ計算不能のためnilを返却する
    electricity_charges_basic_rate = electricity_charges_basic_rates.find_by(ampere: ampere)
    return nil if electricity_charges_basic_rate.nil?

    electricity_charges_usage_rate = electricity_charges_usage_rate_from_usage(usage)
    return nil if electricity_charges_usage_rate.nil?

    # 基本料金（契約アンペア数(A)に対応する基本料金(円)）の計算
    basic_price = electricity_charges_basic_rate.basic_rate

    # 従量料金（電気使用量(kWh) * 従量料金単価(円/kWh)）の計算
    usage_price = usage * electricity_charges_usage_rate.unit_rate

    # 電気料金（基本料金 + 従量料金）を返却
    basic_price + usage_price
  end

  private

  def electricity_charges_usage_rate_from_usage(usage)
    electricity_charges_usage_rates
      .where('min_usage <= :usage AND (max_usage IS NULL OR max_usage >= :usage)', usage: usage)
      .order(:min_usage)
      .first
  end
end
