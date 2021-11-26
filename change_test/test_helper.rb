ENV['RAILS_ENV'] ||= 'test'
require_relative "../config/environment"
require "rails/test_help"
require "minitest/reporters"
Minitest::Reporters.use!

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  include ApplicationHelper

  class ActionDispatch::IntegrationTest
    def log_in(user)
      post login_path,params:{session:{email:user.email,password:"password"}}
    end

    def log_out
      session.clear
    end

    def logged_in?(user)
      !session[:user_id].nil?
    end
  end
end
