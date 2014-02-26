class BankParser
  def initialize
    config = YAML::load_file(File.join(__dir__, 'config.yaml'))
    configatron.configure_from_hash config
    @agent = Mechanize.new
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
    client = DeathByCaptcha.socket_client(configatron.captcha_login, configatron.captcha_password)
    response = client.decode (captcha_url)
    raise 'Captcha was not solved' if response['text'].nil?
    login_form.captcha = response['result']
  end

  def do_login (login_page)
    login_form = login_page.form_with(name: 'F1')
    verify_form login_form
    fill_form login_form
    if login_page.body.match((/NeedCaptcha\s*=\s*-1/))
      m = login_page.body.match(/&s=(.*)\'/)
      raise 'Unable to parse captcha hash' if m.nil?
      hash = m[1]
      captcha_url = "https://www.sbsibank.by/imobile/captcha.ashx?r=0.54457567&s=#{hash}"
      fill_captcha(login_form, captcha_url)
    end
    @agent.submit(login_form)
  end

  def login
    login_page = @agent.get('https://www.sbsibank.by/login.asp')
    result = do_login(login_page)
    if result.form_with(name: 'F1')
      result = do_login(result)
    end
    puts result.body
  end

  def work
    login
  end
end