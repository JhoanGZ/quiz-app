class CreateQuestions < ActiveRecord::Migration[8.1]
  def change
    create_table :questions do |t|
      t.text :body, null: false
      t.references :quiz, null: false, foreign_key: true
      t.string :video_url

      t.timestamps
    end
  end
end
