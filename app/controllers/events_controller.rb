class EventsController < ApplicationController

  skip_before_filter :verify_authenticity_token, :only => [:create]

  def index
    Rails.logger.info "Params:: #{params}"
    @total_docs, @event_aggs = Event.name_per_hour(params)
    # redirect_to show_events_path(params)
  end

  def show
    Rails.logger.info "Params:: #{params}"
    @total_docs, @event_aggs = Event.name_per_hour(params)
  end

  def create
    if current_app and current_client
      events_queue.push(params[:events])
      render json: :ok, status: 200
    else
      render json: :error , status: 403
    end
  end

end
