class SyncerController < AuthenticatedController
  def sync
    received_data = SyncData.new
    received_data.revision = params[:revision].to_i
    received_data.entities = {}

    @sync_data = SyncData.from_sync_data(current_user.id, received_data)
  end

end
