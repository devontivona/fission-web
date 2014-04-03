class AppsController < InheritedResources::Base
  respond_to :html, :json
  actions :all, except: [:show]

  def events

    @end = Time.now.getutc.to_date
    @start = Time.mktime( @end.year, @end.month, 1).to_date
    Rails.logger.info "From Start: #{@start} - End: #{@end}"
    @event_aggs = []
    @total_count = 0
    (@start..@end).each do |date|
      total_count, aggs = Event.name_per_day({day: date.day, app_id: current_app})
      # Rails.logger.info aggs.inject(0) {|sum, hash| Rails.logger.info hash['doc_count']}
      @event_aggs << [date, total_count, aggs]
      @total_count += total_count
    end

    Rails.logger.info "Found events #{@event_aggs.inspect}"
  end

  def permitted_params
    params.permit(app: [:name])
  end
end