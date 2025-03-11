class Provider < ApplicationRecord
  has_many :plans, dependent: :destroy

  validates :name, presence: true, uniqueness: true

  def electricity_prices(ampere, usage)
    plans.map do |plan|
      price = plan.electricity_price(ampere, usage)
      if price
        {
          provider_name: name,
          plan_name: plan.name,
          price: plan.electricity_price(ampere, usage)
        }
      end
    end.compact
  end
end
