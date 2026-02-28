class AddMediaToQuizzes < ActiveRecord::Migration[8.1]
  def change
    add_column :quizzes, :video_url, :string
  end
end
