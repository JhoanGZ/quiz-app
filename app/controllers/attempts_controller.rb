class AttemptsController < ApplicationController
  def create
    @quiz = Quiz.find(params[:quiz_id])
    @attempt = current_user.attempts.build(quiz: @quiz)
    authorize @attempt

    if @attempt.save
      redirect_to attempt_path(@attempt), notice: "¡Quiz iniciado!"
    else
      redirect_to quizzes_path, alert: "No puedes responder este quiz."
    end
  end

  def show
    @attempt = Attempt.find(params[:id])
    authorize @attempt
  end
end

