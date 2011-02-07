
require 'rubygems'
require 'mechanize'
require 'open-uri'
require 'hpricot'
require 'date'

def camelCase(phrase)
  phrase = phrase.scan(/[[:print:]]/).join
  phrase.gsub!(/^[a-z]|\s+[a-z]/) { |a| a.upcase }
  phrase.gsub!(/[\s]/, '')
  phrase.gsub!(/[,)]/, '')
  phrase.gsub!(/[(]/, '-')
  return phrase
end

def fixInteger(num)
  phrase.gsub!(/\(/, '-')
end


def fixDate(indate)
 
  Date.parse("%s %s %s" % [indate[0..2],indate[3..4],indate[5..8]]).to_s
end


def yahooFinanceURLQuery(type,ticker)
   'http://finance.yahoo.com/q/%s?s=%s' % [type,ticker]
end
#
#
#  Get Financial Data from Yahoo-
#
# url: http://finance.yahoo.com/q/
# type: cf=cashflow, bs=balance sheet, is=income statement
# ticker

def getYahooFinancialData(type,ticker)

newTable = Array.new
@dateArray = Array.new

dom = '//*[@class="yfnc_tabledata1"]//tr'

page = Hpricot(open(yahooFinanceURLQuery(type,ticker)))
#page = Hpricot(open("is.html"))

(page/dom).each do |row|

   newRow = Array.new


   (row/'td|th').each do |element|
      newRow << camelCase(element.inner_text.strip)
   end
   newRow.shift if newRow.first == ""
   newTable << newRow if newRow.count > 2
end

reOrderTable = Array.new

##pp newTable if @debug

newTable.each do |param|
    if param[0] == 'PeriodEnding' then 
       param.shift  ## just the dates please.
       param.each {|p| @dateArray << fixDate(p)}
       next
    end
   

    index = 1   ## Indexes, really?  really???

    @dateArray.each do |mydate|   
        reOrderTable  <<  [ticker,mydate,param[0],param[index]]
    index = index + 1
    end 
end
    pp reOrderTable
end

class TableThing 
end

table = getYahooFinancialData('is','T')
##writeit('is.dat',table)
table = getYahooFinancialData('bs','T')
##writeit('bs.dat',table)
table = getYahooFinancialData('cf','T')
##writeit('cf.dat',table)


