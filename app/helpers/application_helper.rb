module ApplicationHelper
  def page(json, paged)
    json.page paged.current_page
    json.total_pages paged.total_pages
    json.total_count paged.total_count
    json.content { yield }
  end
end
