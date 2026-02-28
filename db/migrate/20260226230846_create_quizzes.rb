class CreateQuizzes < ActiveRecord::Migration[8.1]
  def change
    create_table :quizzes do |t|
      t.string :title, null: false
      t.text :description
      t.integer :status, default: 0, null: false
      t.integer :passing_score, default: 70, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
