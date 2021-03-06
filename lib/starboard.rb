require 'thread'
require 'net/http'
require 'activesupport'

#
# Useful constants
#
Starboard_Platform = 'Ruby'
Starboard_Version = 0.2

require File.join(File.dirname(__FILE__), 'starboard', 'event')
require File.join(File.dirname(__FILE__), 'starboard', 'queue')
require File.join(File.dirname(__FILE__), 'starboard', 'worker')
require File.join(File.dirname(__FILE__), 'starboard', 'configuration')

require File.join(File.dirname(__FILE__), 'starboard', 'sources', 'base')