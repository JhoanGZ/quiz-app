class QuestionPolicy < ApplicationPolicy

  def create?
    user.admin
  end

  def update?
    user.admin? && record.quiz.user_id == user.id
  end

  def destroy?
    update?
  end

end

  
