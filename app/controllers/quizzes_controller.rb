class QuizzesController < ApplicationController
  before_action :set_quiz, only: [:show, :edit, :update, :destroy, :publish]

  def index
    @quizzes = policy_scop(Quiz)
  end

  def show
    authorize @quiz
  end

  def new
    @quiz = Quiz.new
    authorize @quiz
  end

  def create
    @quiz = current_user.quizzes.build(quiz_params)
    authorize @quiz

    if @quiz.save
      redirect_to @quiz, notice: "Quizz creado exitosamente!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @quiz
  end

  def update
    authorize @quiz

    if @quiz.update(quiz_params)
      redirect_to @quiz, notice: "Quizz actualizado correctamente!"
    else
      render :edit, status: :unprocessable_entity
    end
  end


  def destroy
    authorize @quiz
    @quiz.destroy
    redirect_to quizzes_path, notice: "Quizz eliminado!"
  end

  def publish
    authorize @quiz
    @quiz.published!
    redirect_to @quiz, notice: "Quizz publicado!"
  end

  private
  
  def set_quiz
    @quiz = Quiz.find(params[:id])
  end

  def quiz_params
    params.require(:quiz).permit(:title, :description, :passing_core)
  end

end



