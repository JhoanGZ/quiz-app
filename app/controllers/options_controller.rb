class OptionsController < ApplicationController
  
  before_action :set_question

  def create
    @option = @question.options.build(option_params)
    authorize @option

    if @option.save
      redirect_to quiz_question_path(@question.quiz, @question), notice: "Opción creada."
    else
      redirect_to quiz_question_path(@question.quiz, @question), alert: "Error al crear opción."
    end
  end

  def destroy
    @option = @question.options.find(params[:id])
    authorize @option
    @option.destroy
    redirect_to quiz_question_path(@question.quiz, @question), notice: "Opción eliminada."
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def option_params
    params.require(:option).permit(:body, :correct)
  end
end
