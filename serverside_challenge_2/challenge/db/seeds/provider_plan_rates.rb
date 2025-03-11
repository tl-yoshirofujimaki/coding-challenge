def create_provider_and_plans(provider_name, plans_data)
  provider = Provider.find_or_create_by!(name: provider_name)

  plans_data.each do |plan_data|
    plan = Plan.find_or_create_by!(provider: provider, name: plan_data[:name])

    create_basic_rates(plan, plan_data[:basic_rates])
    create_usage_rates(plan, plan_data[:usage_rates])
  end
end

def create_basic_rates(plan, rates)
  rates.each do |rate_data|
    EnergyChargesBasicRate.find_or_create_by!(
      plan: plan,
      ampere: rate_data[:ampere]
    ) do |rate|
      rate.basic_rate = rate_data[:basic_rate]
    end
  end
end

def create_usage_rates(plan, rates)
  rates.each do |rate_data|
    EnergyChargesUsageRate.find_or_create_by!(
      plan: plan,
      min_usage: rate_data[:min_usage],
      max_usage: rate_data[:max_usage]
    ) do |rate|
      rate.unit_rate = rate_data[:unit_rate]
    end
  end
end

# 東京電力エナジーパートナー
create_provider_and_plans('東京電力エナジーパートナー', [
  {
    name: '従量電灯B',
    basic_rates: [
      { ampere: 10, basic_rate: 286.00 },
      { ampere: 15, basic_rate: 429.00 },
      { ampere: 20, basic_rate: 572.00 },
      { ampere: 30, basic_rate: 858.00 },
      { ampere: 40, basic_rate: 1144.00 },
      { ampere: 50, basic_rate: 1430.00 },
      { ampere: 60, basic_rate: 1716.00 }
    ],
    usage_rates: [
      { min_usage: 0, max_usage: 120, unit_rate: 19.88 },
      { min_usage: 121, max_usage: 300, unit_rate: 26.48 },
      { min_usage: 301, max_usage: nil, unit_rate: 30.57 }
    ]
  },
  {
    name: 'スタンダードS',
    basic_rates: [
      { ampere: 10, basic_rate: 311.75 },
      { ampere: 15, basic_rate: 467.63 },
      { ampere: 20, basic_rate: 623.50 },
      { ampere: 30, basic_rate: 935.25 },
      { ampere: 40, basic_rate: 1247.00 },
      { ampere: 50, basic_rate: 1558.75 },
      { ampere: 60, basic_rate: 1870.50 }
    ],
    usage_rates: [
      { min_usage: 0, max_usage: 120, unit_rate: 29.80 },
      { min_usage: 121, max_usage: 300, unit_rate: 36.40 },
      { min_usage: 301, max_usage: nil, unit_rate: 40.49 }
    ]
  }
])

# 東京ガス
create_provider_and_plans('東京ガス', [
  {
    name: 'ずっとも電気1',
    basic_rates: [
      { ampere: 30, basic_rate: 858.00 },
      { ampere: 40, basic_rate: 1144.00 },
      { ampere: 50, basic_rate: 1430.00 },
      { ampere: 60, basic_rate: 1716.00 }
    ],
    usage_rates: [
      { min_usage: 0, max_usage: 140, unit_rate: 23.67 },
      { min_usage: 141, max_usage: 350, unit_rate: 23.88 },
      { min_usage: 351, max_usage: nil, unit_rate: 26.41 }
    ]
  }
])

# Looopでんき
create_provider_and_plans('Looopでんき', [
  {
    name: 'おうちプラン',
    basic_rates: [
      { ampere: 10, basic_rate: 0.00 },
      { ampere: 15, basic_rate: 0.00 },
      { ampere: 20, basic_rate: 0.00 },
      { ampere: 30, basic_rate: 0.00 },
      { ampere: 40, basic_rate: 0.00 },
      { ampere: 50, basic_rate: 0.00 },
      { ampere: 60, basic_rate: 0.00 }
    ],
    usage_rates: [
      { min_usage: 0, max_usage: nil, unit_rate: 28.8 }
    ]
  }
])

puts '各電力会社と、そのプラン作成が完了しました'
