class CreateTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks, comment: 'タスク' do |t|
      t.string :name, comment: 'タスク名'
      t.string :category_name, comment: 'カテゴリ名'
      t.references :user, null: false, foreign_key: true, comment: 'ユーザー'
      t.datetime :finished_at, comment: '終了日時'
      t.datetime :deadline, comment: '締切'
      t.text :memo, comment: 'メモ'

      t.timestamps
    end

    add_column :users, :picture, :string
    add_column :users, :email, :string
    add_index :users, %i[provider email], unique: true
  end
end
