$: << File.join(File.dirname(__FILE__), '..', 'lib')
$: << File.join(File.dirname(__FILE__))

require 'rubygems'
gem 'sqlite3-ruby'

require 'test/unit'
require 'rubygems'
require 'ruby-debug'

require 'activerecord'
require 'machine'
require 'mocha'
require 'models'
require 'shoulda'

