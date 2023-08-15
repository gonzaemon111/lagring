class CreateShoppings < ActiveRecord::Migration[7.0]
  def change
    create_table :shoppings, comment: '買い物' do |t|
      t.string :name, default: '', null: false, limit: 255, comment: '買うもの'
      t.text :memo, comment: 'メモ'
      t.string :url, comment: 'URL'
      t.string :image_url, comment: '画像URL'
      t.references :user, null: false, foreign_key: true, comment: 'ユーザー'
      t.string :shop, comment: '店'
      t.integer :price, default: 0, null: false, comment: '金額'
      t.boolean :is_bought, default: false, null: false, comment: '買ったかどうか'

      t.timestamps
    end
  end
end
