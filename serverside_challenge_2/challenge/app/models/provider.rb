class Provider < ApplicationRecord
  has_many :plans, dependent: :destroy

  validates :name, presence: true, uniqueness: true

  def energy_prices(ampere, usage)
    plans.map do |plan|
      price = plan.energy_price(ampere, usage)
      if price
        {
          provider_name: name,
          plan_name: plan.name,
          price: plan.energy_price(ampere, usage)
        }
      end
    end.compact
  end
end
