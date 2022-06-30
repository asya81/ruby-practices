#!/usr/bin/env ruby
require_relative 'calendar'

calendar = Calendar.new
options_error = calendar.initialize_options

if options_error.empty?
  params_errors = calendar.initialize_parameters
else
  puts options_error
  return
end

if params_errors.empty?
  puts calendar.generate
else
  puts params_errors
  return
end
