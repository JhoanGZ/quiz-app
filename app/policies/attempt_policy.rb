class AttemptPolicy < ApplicationPolicy

  def create?
    user.player?
  end

  def show?
    user.admin? || record.user_id == user.id
  end

  # Allow the player to update its own attempt. Only works if it's not completed
  def update?
    user.player? &&
      record.user_id == user.id &&
      record.completed_at.nil?
  end

end
