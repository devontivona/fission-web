class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

private

  def current_app
    @app ||= App.find_by_access_token request.headers["Access-Token"]
  end

  def current_client
    @client ||= Client.find_by_app_id_and_token current_app.id, request.headers["Client-Token"]
  end

  def events_queue
    @events_queue ||= EventQueue.new
  end

  def restrict_access
    head :unauthorized unless current_app
  end

end
