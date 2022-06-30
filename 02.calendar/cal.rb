#!/usr/bin/env ruby
require_relative 'calendar'

calendar = Calendar.new
options, options_error = calendar.initialize_options

if options_error.empty?
  year, month, params_errors = calendar.initialize_parameters(input_year: options["y"], input_month: options["m"])
else
  puts options_error
  return
end

if params_errors.empty?
  puts calendar.generate(year: year, month: month)
else
  puts params_errors
  return
end
