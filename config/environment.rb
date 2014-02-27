require 'rubygems'
require 'active_record'
require 'yaml'
require 'mechanize'
require 'configatron'
require 'deathbycaptcha'
require 'mysql'
require 'date'

environment = ENV['DATABASE_ENV'] || 'development'

# environment.rb
# recursively requires all files in ./lib and down that end in .rb
Dir.glob(File.join(File.dirname(__FILE__),'../lib/*')).each do |folder|
  if File.directory?(folder)
    Dir.glob(folder + '/*.rb').each do |file|
      require file
    end
  else
    require folder
  end
end

config = YAML::load_file(File.join(File.dirname(__FILE__), 'config.yaml'))
configatron.configure_from_hash config

dbconfig = YAML::load_file(File.join(File.dirname(__FILE__), 'database.yml'))

ActiveRecord::Base.logger = Logger.new(STDERR)
ActiveRecord::Base.establish_connection(dbconfig[environment])