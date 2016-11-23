class SyncData
  attr_accessor :revision, :entities

  class << self

    def from_sync_data(scope_id, client_data)
      revision = DateTime.strptime("#{client_data.revision}", '%s')
      # remapped_ids = insert_new_entities(client_data.entities['INSERT'])
      # remap_ids(client_data.entities['UPDATE'], remapped_ids)
      # remap_ids(client_data.entities['REMOVE'], remapped_ids)
      # update_existing_entities(client_data.entities['UPDATE'])
      # delete_entities(client_data.entities['DELETE'])

      server_data = SyncData.new
      server_data.revision = DateTime.now.utc.to_i
      server_data.entities = {}
      server_data.entities['INSERT'] = inserted_entities_since(revision, scope_id)
      server_data.entities['UPDATE'] = updated_entities_since(revision, scope_id)
      #server_data.entities['REMOVE'] = deleted_entities_since(revision, scope_id)
      #server_data.entities['UPDATE_ID'] = remapped_ids

      server_data
    end

    def inserted_entities_since(revision, scope_id)
      ApplicationRecord.insertion_order.map(&:constantize).map do |model|
        model.sync_selectors.map do |selector|
          model.joins(selector[:joins])
              .where(replace_hash_placeholder(selector[:where], scope_id))
              .where("\"#{model.to_s.underscore.pluralize}\".\"created_at\" >= ?", revision).to_a
        end
      end.flatten.sort do |a, b|
        a.created_at <=> b.created_at
      end
    end

    def updated_entities_since(revision, scope_id)
      ApplicationRecord.insertion_order.map(&:constantize).map do |model|
        model.sync_selectors.map do |selector|
          model.joins(selector[:joins])
              .where(replace_hash_placeholder(selector[:where], scope_id))
              .where("\"#{model.to_s.underscore.pluralize}\".\"updated_at\" >= ? AND \"#{model.to_s.underscore.pluralize}\".\"created_at\" < ?", revision, revision).to_a
        end
      end.flatten.sort do |a, b|
        a.updated_at <=> b.updated_at
      end
    end

    def replace_hash_placeholder(hash, value, placeholder = :x)
      hash.keys.each do |key|
        if hash[key].is_a? Hash
          replace_hash_placeholder(hash[key], value, placeholder)
        elsif hash[key] == placeholder
          hash[key] = value
        end
      end if hash
      hash
    end
  end
end
