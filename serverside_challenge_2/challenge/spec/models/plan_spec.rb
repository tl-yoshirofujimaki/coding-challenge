# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Plan, type: :model do
  describe '#electricity_price' do
    let(:provider) { create(:provider) }
    let(:plan) do
      create(:plan, provider: provider, electricity_charges_basic_rates: [], electricity_charges_usage_rates: [])
    end

    let!(:basic_rate_20A) do
      create(:electricity_charges_basic_rate, plan: plan, ampere: 20, basic_rate: 1000)
    end

    let!(:basic_rate_30A) do
      create(:electricity_charges_basic_rate, plan: plan, ampere: 30, basic_rate: 1000)
    end

    let!(:usage_rate_low) do
      create(:electricity_charges_usage_rate, plan: plan, min_usage: 0, max_usage: 120, unit_rate: 20)
    end

    let!(:usage_rate_middle) do
      create(:electricity_charges_usage_rate, plan: plan, min_usage: 121, max_usage: 300, unit_rate: 25)
    end

    let!(:usage_rate_high) do
      create(:electricity_charges_usage_rate, plan: plan, min_usage: 301, max_usage: nil, unit_rate: 30)
    end

    describe '正常系' do
      context 'アンペア数と使用量が条件に合致する場合' do
        let(:ampere) { 20 }
        let(:usage) { 150 }

        it '基本料金と従量料金の合計を返す' do
          expect(
            plan.electricity_price(ampere, usage)
          ).to eq(basic_rate_20A.basic_rate + (usage * usage_rate_middle.unit_rate))
        end
      end

      context '使用量が0の場合' do
        let(:ampere) { 30 }
        let(:usage) { 0 }

        it '基本料金と従量料金（0円）の合計を返す' do
          expect(plan.electricity_price(ampere, usage)).to eq(basic_rate_30A.basic_rate)
        end
      end

      context '使用量が上限のないレートに該当する場合' do
        let(:ampere) { 30 }
        let(:usage) { 0 }

        it '基本料金と従量料金の合計を返す' do
          expect(
            plan.electricity_price(ampere, usage)
          ).to eq(basic_rate_30A.basic_rate + (usage * usage_rate_high.unit_rate))
        end
      end
    end

    describe '異常系' do
      context '指定したアンペア数に対応する基本料金が存在しない場合' do
        let(:ampere) { 40 }
        let(:usage) { 150 }

        it 'nilを返す' do
          expect(plan.electricity_price(ampere, usage)).to be_nil
        end
      end
    end
  end
end
