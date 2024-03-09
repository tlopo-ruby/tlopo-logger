# frozen_string_literal: true

require 'logger'
require 'json'
require_relative 'logger/version'

DefaultLogger = Logger

module Tlopo
  class CustomLogger < DefaultLogger
    @@sensitive = {}

    def initialize(dev, **args)
      super
      if ENV['LOG_LEVEL']
        @level = Object.const_get "Logger::#{ENV['LOG_LEVEL'].upcase}"
      else
        @level = DefaultLogger::INFO
      end

      if ENV['LOG_JSON'] == 'true'
        @formatter = proc do |severity, datetime, progname, msg|
          log = { level: severity, time: datetime.to_s, message: msg }
          log[:backtrace] = msg.backtrace.join("\n") if msg.is_a?(Exception) && !msg.backtrace.nil?
          log[:app] = progname unless progname.nil?
          log = "#{log.to_json}\n"
          @@sensitive.each { |k, v| log = log.gsub(v, "[REDACTED:#{k}]") }
          log
        end
      else
        formatter = DefaultLogger::Formatter.new
        @formatter = proc do |severity, datetime, progname, msg|
          log = formatter.call severity, datetime, progname, msg
          @@sensitive.each { |k, v| log = log.gsub(v, "[REDACTED:#{k}]") }
          log
        end
      end
    end

    def add_sensitive(key, val)
      @@sensitive[key] = val
    end
  end
end

LOGGER ||= Tlopo::CustomLogger.new $stderr
