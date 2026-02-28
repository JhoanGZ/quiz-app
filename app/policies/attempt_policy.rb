class AttemptPolicy < ApplicationPolicy

  def create?
    user.player?
  end

  def show?
    user.admin? || record.user_id == user.id
  end

end
