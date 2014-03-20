class ClientsController < InheritedResources::Base
  respond_to :html, :json
  actions :all, except: [:new, :edit]
  before_filter :restrict_access, only: :create

  def create
    @client = Client.find_or_create_by_app_id_and_token current_app.id, params[:client][:token]
    @client.update_attributes permitted_params
    create!
  end

  def permitted_params
    params.require(:client).permit(:library, :version, :manufacturer, :os, :os_version, :model, :carrier, :token)
  end
end
