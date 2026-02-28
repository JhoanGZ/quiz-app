class CreateOptions < ActiveRecord::Migration[8.1]
  def change
    create_table :options do |t|
      t.string :body, null: false
      t.references :question, null: false, foreign_key: true
      t.boolean :correct , default: false, null: false

      t.timestamps
    end
  end
end
