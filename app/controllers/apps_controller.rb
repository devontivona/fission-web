class AppsController < InheritedResources::Base
  respond_to :html, :json
  actions :all, except: [:show]

  def permitted_params
    params.permit(app: [:name])
  end
end