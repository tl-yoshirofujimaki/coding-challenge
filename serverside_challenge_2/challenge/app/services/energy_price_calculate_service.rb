class EnergyPriceCalculateService
  def initialize(ampere, usage)
    @ampere = ampere
    @usage = usage
  end

  def calc
    Provider.order(:id).map{|provider| provider.energy_prices(@ampere, @usage)}.flatten
  end
end

