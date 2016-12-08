class ApplicationController < ActionController::Base
  include DeviseTokenAuth::Concerns::SetUserByToken
  protect_from_forgery with: :exception, unless: Proc.new { |c| c.request.format.json? }
end
