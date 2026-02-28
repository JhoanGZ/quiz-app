class QuizPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    user.admin? || record.published?
  end

  def create?
    user.admin?
  end

  def update?
    user.admin? && record.user_id == user.id
  end

  def destroy?
    user.admin? && record.user_id == user.id
  end

  def publish?
    update?
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      if user.admin?
        scope.all
      else
        scope.where(status: :published)
      end
    end
  end
end
