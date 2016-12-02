json.extract! billing_account, :id, :user_id, :name, :enabled, :created_at, :updated_at
json.url billing_account_url(billing_account, format: :json)