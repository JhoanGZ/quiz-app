class Api::V1::AttemptsController < Api::V1::BaseController
  
  def create
    quiz = Quiz.find(params[:quiz_id])
    attempt = current_user.attempts.build(quiz: quiz)
    authorize attempt

    answers_params = params.require(:answers)

    ActiveRecord::Base.transaction do
      attempt.save!

      answers_params.each do |answer|
        attempt.answers.create!(
          question_id: answer[:question_id],
          option_id: answer[:option_id]
        )
      end

      correct_count = attempt.answers.joins(:option).where(options: { correct: true }).count
      total = attempt.answers.count
      attempt.update!(
        score: (correct_count.to_f / total * 100).round,
        completed_at: Time.current
      )
    end

    render json: {
      id: attempt.id,
      quiz: quiz.title,
      score: attempt.score,
      passing_score: quiz.passing_score,
      passed: attempt.score >= quiz.passing_score,
      total_questions: attempt.answers.count,
      correct_answers: attempt.answers.joins(:option).where(options: { correct: true }).count,
      details: attempt.answers.map { |a|
        {
          question: a.question.body,
          selected: a.option.body,
          correct: a.option.correct?
        }
      }
    }, status: :created

  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.record.errors.messages.values.flatten.first }, status: :unprocessable_entity
  end

  def show
    attempt = Attempt.find(params[:id])
    authorize attempt

    render json: {
      id: attempt.id,
      quiz: attempt.quiz.title,
      score: attempt.score,
      passing_score: attempt.quiz.passing_score,
      passed: attempt.score >= attempt.quiz.passing_score,
      completed_at: attempt.completed_at,
      details: attempt.answers.map { |a|
        {
          question: a.question.body,
          selected: a.option.body,
          correct: a.option.correct?
        }
      }
    }
  end
end
