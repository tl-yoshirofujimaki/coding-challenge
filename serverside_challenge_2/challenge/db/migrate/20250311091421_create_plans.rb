class CreatePlans < ActiveRecord::Migration[7.0]
  def change
    create_table :plans, comment: '各電力会社毎のプランを格納する' do |t|
      t.references :provider, null: false, foreign_key: true
      t.string :name, null: false, comment: 'プラン名'

      t.timestamps
    end

    add_index :plans, [:provider_id, :name], unique: true
  end
end
