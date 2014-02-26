require 'rubygems'
require 'yaml'
require 'mechanize'
require 'configatron'
require 'deathbycaptcha'
require './bank_parser'

parser = BankParser.new
parser.work