class AppsController < InheritedResources::Base
  respond_to :html, :json
  actions :all, except: [:show]

  def events

    @end = Time.now.getutc.to_date
    @start = Time.mktime( @end.year, @end.month, 1).to_date
    Rails.logger.info "From Start: #{@start} - End: #{@end}"
    @total_count = 0
    @event_aggs = {}

    (@start..@end).each do |date|
      total_count, aggs = Event.name_per_day({year: date.year, month: date.month, day: date.day, app_id: current_app})
      @total_count += total_count
      aggs.each do |hash|
        @event_aggs[hash['key']] = @event_aggs.has_key?(hash['key']) ? (@event_aggs[hash['key']]+hash['doc_count']) : hash['doc_count']
      end
    end

    Rails.logger.info "Found events #{@event_aggs.inspect}"
  end

  def permitted_params
    params.permit(app: [:name])
  end
end