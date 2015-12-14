# =====  Rails Setup  =====
# This probably works with other versions, too,
# but these are the ones I figured it out on
gem 'rails',    '4.2.4'
gem 'capybara', '2.5.0'

# Just enough Rails to illustrate the idea
require "rails"
require 'action_controller/railtie'
class ExampleApp < Rails::Application
  secrets.secret_key_base = "ffaaf61864e..."
  initialize!
  routes.draw { root 'site#index' }
end


# =====  Controller To Test  =====
class SiteController < ActionController::Base
  def index
    render text: "Your IP address: #{request.remote_ip}"
    # => ["Your IP address: 0.0.0.0"]
    #    ,["Your IP address: minitest-override"]
  end
end


# =====  Minitest Controller Test  =====
require 'action_controller/test_case'
Rails.application.config.active_support.test_order = :random
class ActionController::TestCase
  setup { @routes = Rails.application.routes }
end

class SiteControllerTest < ActionController::TestCase
  name = test "Reports my ip" do
    # the default
    assert_equal 'Your IP address: 0.0.0.0', get(:index).body

    # lets override it
    request.env['REMOTE_ADDR'] = 'minitest-override'
    assert_equal 'Your IP address: minitest-override', get(:index).body
  end

  SiteControllerTest.new(name).run.passed? # => true
end
