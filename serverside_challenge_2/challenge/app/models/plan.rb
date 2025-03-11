class Plan < ApplicationRecord
  belongs_to :provider
  has_many :energy_charges_basic_rates, dependent: :destroy
  has_many :energy_charges_usage_rates, dependent: :destroy

  validates :name, presence: true, uniqueness: { scope: :provider_id }

  def energy_price(ampere, usage)
    # 基本料金（契約アンペア数(A)に対応する基本料金(円)）の計算
    energy_charges_basic_rate = energy_charges_basic_rates.find_by(ampere: ampere)
    basic_price = energy_charges_basic_rate.basic_rate

    # 従量料金（電気使用量(kWh) * 従量料金単価(円/kWh)）の計算
    energy_charges_usage_rate = energy_charges_usage_rate_from_usage(usage)
    usage_price = usage * energy_charges_usage_rate.unit_rate

    # 電気料金（基本料金 + 従量料金）を返却
    return basic_price + usage_price
  end

  def energy_charges_usage_rate_from_usage(usage)
    energy_charges_usage_rates
      .where('min_usage <= :usage AND (max_usage IS NULL OR max_usage >= :usage)', usage: usage)
      .order(:min_usage)
      .first
  end
end
