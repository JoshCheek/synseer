# =====  Rails Setup  =====
# This probably works with other versions, too, but these are the ones I figured it out on
gem 'rails',       '4.2.4'
gem 'capybara',    '2.5.0'
gem 'rspec-rails', '3.3.3'

# Just enough Rails to illustrate the idea
require "rails"
require 'action_controller/railtie'
class ExampleApp < Rails::Application
  secrets.secret_key_base = "ffaaf61864e14edf3496df94a3ec3a24050495a0dcc8727dba1ebc7cf6594616479c741329a066ce5387fdf9d0205bfebb8a9549cc4d314c6738e62ad3fda676"
  initialize!
  routes.draw { root 'site#index' }
end


# =====  Controller To Test  =====
class SiteController < ActionController::Base
  def index
    render text: "Your IP address: #{request.remote_ip}"
    # => ["Your IP address: 0.0.0.0"]
    #    ,["Your IP address: minitest-override"]
    #    ,["Your IP address: 0.0.0.0"]
    #    ,["Your IP address: rspec-override"]
    #    ,["Your IP address: 127.0.0.1"]
    #    ,["Your IP address: 1.2.3.4"]
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
    assert_equal 'Your IP address: 0.0.0.0', get(:index).body # the default

    request.env['REMOTE_ADDR'] = 'minitest-override' # lets override it
    assert_equal 'Your IP address: minitest-override', get(:index).body
  end

  SiteControllerTest.new(name).run.passed? # => true
end


# =====  RSpec Controller Test  =====
require 'rspec/rails'
RSpec.describe SiteController, type: :controller do
  it 'reports my ip' do
    expect(get(:index).body).to eq 'Your IP address: 0.0.0.0' # the default

    request.env['REMOTE_ADDR'] = 'rspec-override' # the override
    expect(get(:index).body).to eq 'Your IP address: rspec-override'
  end

  run
  examples.first.execution_result.status # => :passed
end


# =====  RSpec Capybara Test  =====
RSpec.describe SiteController, type: :feature do
  it 'reports my ip' do
    page.visit '/'
    expect(page.body).to eq 'Your IP address: 127.0.0.1' # the default

    # The override (this goes through the full middleware stack, like a real request, so no english IPs)
    app  = lambda { |env| Rails.application.call env.merge('REMOTE_ADDR' => '1.2.3.4') }
    page = Capybara::Session.new :rack_test, app
    page.visit '/' # note that this is the local variable `page`, not the method `page`
    expect(page.body).to eq 'Your IP address: 1.2.3.4'
  end

  run
  examples.first.execution_result.status # => :passed
end
