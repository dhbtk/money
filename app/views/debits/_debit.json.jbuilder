json.extract! debit, :id, :name, :date, :value, :recurring_debit_id, :account_id, :tag_id, :credit_id, :created_at, :updated_at
json.url debit_url(debit, format: :json)