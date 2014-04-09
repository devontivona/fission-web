class AppsController < InheritedResources::Base
  respond_to :html, :json
  actions :all, except: [:show]

  def show
    @end = Time.now.getutc.to_date
    @start = Time.mktime( @end.year, @end.month, 1).to_date
    @current_app = App.find params[:id]

    @total_count, @event_aggs = get_bucket_metrics(params[:id], @start, @end)
    Rails.logger.info "Found events #{@event_aggs.inspect}"

    respond_to do |format|
      format.html { render 'show' }
      format.json { render json: {total_count: @total_count}.merge(@event_aggs) }
    end
  end

  def metrics
    @end = params.has_key?(:end_date) ? Time.strptime(params[:end_date], "%m/%d/%Y").getutc.to_date : Time.now.getutc.to_date
    @start = params.has_key?(:start_date) ? Time.strptime(params[:start_date], "%m/%d/%Y").getutc.to_date : Time.now.getutc.to_date

    @current_app = App.find params[:id]
    @total_count, @event_aggs = get_bucket_metrics(params[:id], @start, @end)

    respond_to do |format|
      format.html { render partial: 'metrics' }
      format.json { render json: {total_count: @total_count}.merge(@event_aggs) }
    end
  end

  def permitted_params
    params.permit(app: [:name])
  end

  def get_bucket_metrics(app_id, start, finish)

    Rails.logger.info "From Start: #{start} - End: #{finish}"
    total_count = 0
    event_aggs = {}
    
    (start..finish).each do |date|
      count, aggs = Event.name_per_day({year: date.year, month: date.month, day: date.day, app_id: app_id})
      total_count += count
      aggs.each do |hash|
        event_aggs[hash['key']] = event_aggs.has_key?(hash['key']) ? (event_aggs[hash['key']]+hash['doc_count']) : hash['doc_count']
      end
    end

    return total_count, event_aggs
  end
end