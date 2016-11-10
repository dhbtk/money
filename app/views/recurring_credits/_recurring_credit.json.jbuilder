json.extract! recurring_credit, :id, :name, :months, :day, :value, :account_id, :expiration, :interest, :fine, :created_at, :updated_at
json.url recurring_credit_url(recurring_credit, format: :json)