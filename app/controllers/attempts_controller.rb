class AttemptsController < ApplicationController
  def create
    @quiz = Quiz.find(params[:attempt][:quiz_id])
    @attempt = current_user.attempts.build(quiz: @quiz)
    authorize @attempt
    if @attempt.save
      redirect_to attempt_path(@attempt), notice: "¡Quiz iniciado!"
    else
      redirect_to quizzes_path, alert: "No puedes responder este quiz."
    end
  end

  def show
    @attempt = Attempt.includes(answers: :option, quiz: { questions: :options }).find(params[:id])
    authorize @attempt
  end

  def update
    @attempt = Attempt.includes(quiz: { questions: :options }).find(params[:id])
    authorize @attempt

    answers_params = params[:answers] || {}

    ActiveRecord::Base.transaction do
      # Prevent duplicate answers on resubmit
      @attempt.answers.destroy_all

      answers_params.each do |question_id, option_id|
        @attempt.answers.create!(
          question_id: question_id,
          option_id: option_id
        )
      end

      correct_count = @attempt.answers
        .joins(:option)
        .where(options: { correct: true })
        .count
      total = @attempt.quiz.questions.count

      @attempt.update!(
        score: (correct_count.to_f / total * 100).round,
        completed_at: Time.current
      )
    end

    redirect_to attempt_path(@attempt), notice: "¡Quiz completado!"
  rescue ActiveRecord::RecordInvalid => e
    redirect_to attempt_path(@attempt), alert: "Error al guardar respuestas: #{e.message}"
  end
end
