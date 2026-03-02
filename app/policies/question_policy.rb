class QuestionPolicy < ApplicationPolicy

  def show?
    user.admin? && record.quiz.user_id == user.id
  end

  def create?
    user.admin?
  end

  def update?
    user.admin? && record.quiz.user_id == user.id
  end

  def destroy?
    update?
  end

end

  
