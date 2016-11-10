json.extract! credit, :id, :name, :date, :value, :recurring_credit_id, :account_id, :expiration_day, :interest, :fine, :created_at, :updated_at
json.url credit_url(credit, format: :json)