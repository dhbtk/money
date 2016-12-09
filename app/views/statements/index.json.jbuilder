page json, @statements do
  json.array! @statements do |statement|
    json.extract! statement, :id, :type, :account_id, :tag_id, :name, :date, :value, :created_at, :updated_at
    json.account do
      json.extract! statement.account, :id, :name, :created_at, :updated_at
    end
    if statement.transfer.present?
      json.transfer do

      end
    end
  end
end
