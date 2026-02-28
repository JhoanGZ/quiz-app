class Api::V1::BaseController < ActionController::API
  include Pundit::Authorization

  before_action :authenticate_api_user!

  rescue_from Pundit::NotAuthorizedError do
    render json: { error: "Recurso no disponible" }, status: :forbidden
  end


  rescue_from ActiveRecord::RecordNotFound do
    render json: { error: "Recurso no encontrado" }, status: :not_found
  end

  private

  def authenticate_api_user!
    @current_user = User.find_by(email: request.headers["X-User-Email"])
    render json: { error: "Solicitud no valida" }, status: :unauthorized unless @current_user
  end

  def current_user
    @current_user
  end
end


                  

