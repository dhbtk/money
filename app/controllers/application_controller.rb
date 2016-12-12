class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception, unless: Proc.new { |c| c.request.format.json? }
end
