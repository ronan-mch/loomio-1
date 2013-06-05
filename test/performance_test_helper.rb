require "test_helper"
require "capybara/rails"
 
module ActionDispatch
  class PerformanceTest
    include Capybara::DSL
  end
end
