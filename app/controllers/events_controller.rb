class EventsController < ApplicationController

  skip_before_filter :verify_authenticity_token, :only => [:create]

  def show
    Rails.logger.info "Params:: #{params}"
    params[:app_id] = 1
    @total_docs, @event_aggs = Event.name_per_hour(params)

  end

  def create
    # Rails.logger.info "#{current_app.access_token} #{current_client.token} #{params[:events]}" 
    # Rails.logger.info "#{request.headers['Client-Token']}||#{request.headers['Access-Token']}"
    if current_app and current_client
      # Rails.logger.info "#{current_app.access_token} #{current_client.token} #{params[:events]}" 
      events_queue.push(params[:events])
      render json: :ok, status: 200
    else
      render json: :error , status: 403
    end
  end

end
