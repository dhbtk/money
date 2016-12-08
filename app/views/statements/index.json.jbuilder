json.content do
json.array! @statements do |statement|
	json.extract! statement, :id, :type, :account_id, :tag_id, :name, :date, :value, :created_at, :updated_at
end
end
json.page params[:page] || 1
json.total_pages @statements.total_pages
json.total_count @statements.total_count
