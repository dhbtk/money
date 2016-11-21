require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
# require "action_cable/engine"
require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Money
  class Application < Rails::Application
    config.i18n.default_locale = :"pt-BR"
    config.i18n.available_locales = %w(en pt-BR)

    # Removes field_with_errors
    config.action_view.field_error_proc = Proc.new do |html_tag, instance|

      el = Nokogiri::HTML::DocumentFragment.parse(html_tag).css('input')
      if el.empty?
        "#{html_tag}".html_safe
      else
        el.add_class('error')
        el.to_s.html_safe
      end
    end
  end
end
