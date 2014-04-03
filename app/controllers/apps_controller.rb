class AppsController < InheritedResources::Base
  respond_to :html, :json
  actions :all, except: [:show]

  def events
    @total_docs, @event_aggs = Event.name_per_hour(params)
  end

  def permitted_params
    params.permit(app: [:name])
  end
end