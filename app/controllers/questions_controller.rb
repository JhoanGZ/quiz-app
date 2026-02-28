class QuestionsController < ApplicationController
  
  before_action :set_quiz
  before_action :set_question, only: [:show, :edit, :update, :destroy]

  def show
    authorize @question
  end

  def new 
    @question = @quiz.questions.build
    authorize @question
  end

  def create 
    @question = @quiz.questions.build(question_params)
    authorize @question

    if @question.save
      redirect_to quiz_question_path(@quiz, @question), notice: "Pregunta creada."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @question
  end

  def update
    authorize @question

    if @question.update(question_params)
      redirect_to quiz_question_path(@quiz, @question), notice: "Pregunta actualizada"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @question
    @question.destroy
    redirect_to @quiz, notice: "Pregunta eliminada."
  end

  private

  def set_quiz
    @quiz = Quiz.find(params[:quiz_id])
  end
  
  def set_question
    @question = @quiz.questions.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:body, :video_url, :image)
  end
end

