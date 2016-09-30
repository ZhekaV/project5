module Parser
  require 'open-uri'

  attr_accessor :parse_url, :parse_pages

  def parse
    return false if parse_url.blank? || parse_pages.blank?
    titles = parsing
    send_message unless user.blank?
    save_results titles
  end

  private

  def parsing
    records = []
    (1..parse_pages.to_i).each do |n|
      page = Nokogiri::HTML(open("#{parse_url}?p=#{n}#info"))
      page.css("div#content div[class='post']").each do |block|
        info = get_info(block)
        records << info unless info.nil?
      end
    end

    to_db(records)
  end

  def send_message
    message = {
      channel: "/messages/#{user.auth_token}",
      data: { type: :parser, status: :ok },
      ext: { auth_token: FAYE_TOKEN }
    }
    uri = URI.parse('http://localhost:9292/faye')
    Net::HTTP.post_form(uri, message: message.to_json)
  end

  def save_results(titles)
    titles # TODO: save to redis so user can see it on temp page
  end

  def get_info(block)
    return if block_denied(block)
    fe_id = block.css("div[class='blc-image'] a").first['href'].delete('/').to_i
    info = {}
    block.css('table tr').each do |row|
      info[row.css('td').first.text.delete(':').parameterize.underscore.to_sym] = row.css('td').last.text
    end
    info[:released] = DateTime.strptime(info[:released], '%d.%m.%Y')
    return unless filter(info)
    Music.new(
      fe_id: fe_id,
      title: block.css("div[class='post-title'] h3").text,
      artwork_url: block.css("div[class='blc-image'] img").first['src'],
      score: block.css("span[id='rate-r-#{fe_id}']").text.to_f,
      votes: block.css("span[id='rate-v-#{fe_id}']").text.to_i,
      posted: posted_date(block.css("div[class='post-title']").css("div[class='post-info'] span").first.text),
      style: info[:style],
      label: info[:label],
      released: info[:released],
      res_type: info[:type],
      version: 1
    )
  end

  def block_denied(block)
    block.css("div[class='post-text']").blank?
  end

  def filter(info)
    info[:released].year >= 2014 && info[:type] != 'Radioshow'
  end

  def posted_date(string)
    string = string.gsub('в ', '')
    a = string.split(' ')
    time = a.last.split(':')
    if %w(Сегодня Вчера).include? a[0]
      date = (a[0] == 'Сегодня' ? Date.today : Date.yesterday)
      Time.local(date.year, date.month, date.day, time[0], time[1])
    else
      Time.local(a[2].to_i, months[a[1]], a[0])
    end
  end

  def months
    {
      'янв'  => 1,
      'фев'  => 2,
      'мар'  => 3,
      'апр'  => 4,
      'мая'  => 5,
      'июн'  => 6,
      'июл'  => 7,
      'авг'  => 8,
      'сен'  => 9,
      'окт'  => 10,
      'ноя'  => 11,
      'дек'  => 12
    }
  end

  def to_db(records)
    return nil, nil if records.blank?
    new = []
    new_titles = []
    exist_titles = []

    records.each do |r|
      exist = Music.find_by_title(r.title)
      if exist.blank?
        new << r
        new_titles << r.title
      else
        exist.update_attributes(rating: r.rating, score: r.score, votes: r.votes)
        exist_titles << exist.title
      end
    end

    Music.import new

    [new_titles, exist_titles]
  end
end
