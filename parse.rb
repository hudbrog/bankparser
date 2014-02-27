require './config/environment'

parser = BankParser.new
parser.work
#
#f=File.read('/tmp/statement.xml')
#statement = Statement.new(f)
#statement.parse
