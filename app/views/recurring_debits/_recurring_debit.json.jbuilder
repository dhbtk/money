json.extract! recurring_debit, :id, :name, :months, :day, :value, :account_id, :created_at, :updated_at
json.url recurring_debit_url(recurring_debit, format: :json)