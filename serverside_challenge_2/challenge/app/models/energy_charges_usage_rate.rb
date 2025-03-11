class EnergyChargesUsageRate < ApplicationRecord
  belongs_to :plan

  validates :min_usage, :unit_rate, presence: true
  validates :max_usage, numericality: { greater_than: :min_usage }, allow_nil: true

  validate :validate_usage_ranges

  private

  def validate_usage_ranges
    # usageがplan内で重複していないかを確認する
    energy_chages_usage_rates = EnergyChargesUsageRate.where(plan: plan).order(:min_usage)
    before_max_usage = nil
    energy_chages_usage_rates.each do |rates|
      if before_max_usage.present? && rates.min_usage <= before_max_usage
        errors.add(:base, '同一プラン内で使用量の範囲が他のレコードと重複しています')
        break
      end

      before_max_usage = rates.max_usage
    end

    if energy_chages_usage_rates.where(max_usage: nil).count > 1
      errors.add(:base, '同一プラン内で使用量上限がない項目が2つ以上存在します')
    end
  end
end
