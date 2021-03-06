class BankParser
  def initialize
    @agent = Mechanize.new
    @agent.log = Logger.new 'mech.log'
    @agent.user_agent_alias = 'Mac Mozilla'

    @dbc_client = DeathByCaptcha.socket_client(configatron.captcha_login, configatron.captcha_password)
  end

  def verify_form (form)
    raise 'Cannot find login form' if form.nil?
    raise 'No username field with default name' if form.T1.nil?
    raise 'No password field with default name' if form.T2.nil?
    raise 'No bank select dropdown' if form.S1.nil?
    raise 'No CAPTCHA field' if form.captcha.nil?
  end

  def fill_form (login_form)
    login_form.T1 = configatron.name
    login_form.T2 = configatron.password
    bank_select = login_form.field_with(name: 'S1')
    bank_option = bank_select.options.select { |b| b.text == configatron.bank }[0]
    raise 'Specified Bank type not found' if bank_option.nil?
    bank_option.select
  end

  def fill_captcha (login_form, captcha_url)
    path = @agent.get(captcha_url, [], 'https://www.sbsibank.by/login.asp?mode=1').save '/tmp/captcha.png'
    raise 'We were unable to save captcha to file' if path.nil?
    file = File.open(path, 'r')
    response = @dbc_client.decode file
    raise 'Captcha was not solved' if response['text'].nil?
    @cid = response['captcha']
    login_form.captcha = response['text']
  end

  def report_bad_captcha
    @dbc_client.report(@cid)
  end

  def do_login (login_page)
    login_form = login_page.form_with(name: 'F1')
    verify_form login_form
    fill_form login_form
    if login_page.body.match((/NeedCaptcha\s*=\s*-1/))
      m = login_page.body.match(/&s=(.*)\'/)
      raise 'Unable to parse captcha hash' if m.nil?
      hash = m[1]
      captcha_url = "https://www.sbsibank.by/imobile/captcha.ashx?r=0.36236535757780075&s=#{hash}"
      fill_captcha(login_form, captcha_url)
      m2 = login_page.body.match(/F1.T2.value\s*=\s*"(\d+)"/)
      login_form.T2 = m2[1] if m2
    end
    button = login_form.button_with(name: 'B1')
    @agent.submit(
        login_form,
        button,
        {
            'Accept'        => 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
            'Origin'        => 'https://sbsibank.by',
            'Cache-Control' => 'max-age=0'
        }
    )
  end

  def login
    login_page = @agent.get('https://www.sbsibank.by/login.asp')
    result = do_login(login_page)
    if result.form_with(name: 'F1')
      result = do_login(result)
    end
    #puts result.body
    if result.form_with(name: 'F1')
      report_bad_captcha
      raise 'We were unable to login even with captcha'
    end
    true
  end

  def get_stat
    right = @agent.get(
        'https://www.sbsibank.by/right.asp',
        [],
        'https://www.sbsibank.by/home.asp'
    )
    mcards = right.form_with(name: 'mcards')
    raise 'No cards found' if mcards.radiobutton_with(name: 'R1').nil?
    crd_id = mcards.radiobutton_with(name: 'R1').value
    mbottom = @agent.get(
        "https://www.sbsibank.by/mbottom.asp?crd_id=#{crd_id}",
        [],
        'https://www.sbsibank.by/right.asp'
    )

    page = @agent.get('https://www.sbsibank.by/statement_xml.asp?F=XML&O=A', [], 'https://www.sbsibank.by/statement.asp?O=A')
    page.body
  end

  def work
    login
    Statement.new(get_stat).parse
  end
end