class Api::V1::QuizzesController < Api::V1::BaseController
  
  def index
    quizzes = policy_scope(Quiz)
    render json: quizzes.map { |quiz|
      {
        id: quiz.id,
        title: quiz.title,
        description: quiz.description,
        status: quiz.status,
        passing_score: quiz.passing_score,
        questions_count: quiz.questions.count,
        created_by: quiz.user.email
      }
    }
  end

  def show
    quiz = Quiz.find(params[:id])
    authorize quiz

    render json: {
      id: quiz.id,
      title: quiz.title,
      description: quiz.description,
      status: quiz.status,
      passing_score: quiz.passing_score,
      questions: quiz.questions.map { |q| 
        {
          id: q.id,
          body: q.body,
          video_url: q.video_url,
          options: q.options.map { |o|
            {
              id: o.id,
              body: o.body
            }
          }
        }
      }
    }
  end
end

