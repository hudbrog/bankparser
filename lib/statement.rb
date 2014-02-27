# encoding: utf-8
class Statement
  def initialize (xml)
    @xml = xml
  end

  def parse
    doc = Nokogiri::XML(@xml)

    rows = doc.xpath("//Row")

    #<Row>
    #  <Date>26.02.2014</Date>
    #  <Desc>Retail BLR MINSK SHOP "SOSEDI"</Desc>
    #  <Auth>664612</Auth>
    #  <TransAmount>-39550</TransAmount>
    #  <TransCurr>BYR</TransCurr>
    #  <AccAmount>-39550</AccAmount>
    #  <AccCurr>BYR</AccCurr>
    #</Row>
    rows.each do |row|
      date = row.xpath('Date').text
      desc = row.xpath('Desc').text
      auth = row.xpath('Auth').text
      tamount = row.xpath('TransAmount').text
      trcurr = row.xpath('TransCurr').text
      aamount = row.xpath('AccAmount').text
      acccurr = row.xpath('AccCurr').text

      next if date.empty?

      tr = if auth.empty?
             Transaction.where(date: Date.parse(date), desc: desc, trans_amount: tamount).first
           else
             Transaction.where(auth: auth).first
           end

      Transaction.create! do |t|
        t.date         = date
        t.desc         = desc
        t.auth         = auth.empty? ? nil: auth
        t.trans_amount = tamount
        t.trans_curr   = trcurr
        t.acc_amount   = aamount
        t.acc_curr     = acccurr
      end if tr.nil?

      puts "On #{date} #{desc} did a transaction #{auth}"
    end
  end

end