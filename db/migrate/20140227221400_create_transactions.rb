class CreateTransactions < ActiveRecord::Migration
  def up
    #  <Date>26.02.2014</Date>
    #  <Desc>Retail BLR MINSK SHOP "SOSEDI"</Desc>
    #  <Auth>664612</Auth>
    #  <TransAmount>-39550</TransAmount>
    #  <TransCurr>BYR</TransCurr>
    #  <AccAmount>-39550</AccAmount>
    #  <AccCurr>BYR</AccCurr>
    create_table :transactions do |t|
      t.date   :date
      t.string :desc
      t.string :auth, null: true
      t.float  :trans_amount
      t.string :trans_curr
      t.float  :acc_amount
      t.string :acc_curr
    end
  end

  def down
    drop_table :transactions
  end
end