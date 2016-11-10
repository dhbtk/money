json.extract! account, :id, :name, :expiration, :type, :interest, :fine, :created_at, :updated_at
json.url account_url(account, format: :json)