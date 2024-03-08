# frozen_string_literal: true

require 'test_helper'
require 'fileutils'

module Tlopo
  class TestLogger < Minitest::Test
    def test_that_it_has_a_version_number
      refute_nil ::Tlopo::Logger::VERSION
    end

    def test_it_logs_in_json
      r, w = IO.pipe
      ENV['LOG_JSON'] = 'true'
      ENV['LOG_LEVEL'] = 'debug'
      logger = Tlopo::CustomLogger.new w
      ENV['LOG_JSON'] = nil
      ENV['LOG_LEVEL'] = nil
      logger.info 'foo'
      out = JSON.parse r.gets
      [r, w].each(&:close)
      assert_equal 'foo', out['message']
    end

    def test_it_omits_sensitive_values
      r, w = IO.pipe
      logger = Tlopo::CustomLogger.new w
      logger.add_sensitive 'password', 'pass123'
      logger.info 'My password is pass123'
      out = r.gets
      assert_match /REDACTED:password/, out
      [r, w].each(&:close)
    end
  end
end
