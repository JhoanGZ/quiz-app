class AttemptPolicy < ApplicationPolicy

  def create?
    user.player?
  end

  def show?
    user.admin? || record.user_id == user.id
  end

  # Permitir que el player actualice solo su propio intento
  # y solo si aún no está completado
  def update?
    user.player? &&
      record.user_id == user.id &&
      record.completed_at.nil?
  end

end
