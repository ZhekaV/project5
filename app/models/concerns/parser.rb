module Parser
  require 'open-uri'

  attr_accessor :parse_url, :parse_pages, :records, :existed_records

  def parse
    return false if parse_url.blank? || parse_pages.blank?
    through_the_pages
  end

  private

  def through_the_pages
    self.records = []
    (1..parse_pages.to_i).each do |n|
      page = Nokogiri::HTML(open("#{parse_url}?p=#{n}#info"))
      page.css("div#content div[class='post']").each do |block|
        records << info_from(block)
      end
    end
    import_to_db
  end

  def info_from(block)
    return if prohibited?(block)
    fe_id = block.css("div[class='blc-image'] a").first['href'].delete('/').to_i
    info = {}
    block.css('table tr').each do |row|
      info[row.css('td').first.text.delete(':').parameterize.underscore.to_sym] = row.css('td').last.text
    end
    info[:released] = DateTime.strptime(info[:released], '%d.%m.%Y')
    return unless filtered(info)
    Music.new(
      fe_id:        fe_id,
      title:        block.css("div[class='post-title'] h3").text,
      artwork_url:  block.css("div[class='blc-image'] img").first['src'],
      score:        block.css("span[id='rate-r-#{fe_id}']").text.to_f,
      votes:        block.css("span[id='rate-v-#{fe_id}']").text.to_i,
      posted:       posted_date(block.css("div[class='post-title']").css("div[class='post-info'] span").first.text),
      style:        info[:style],
      label:        info[:label],
      released:     info[:released],
      res_type:     info[:type]
    )
  end

  def prohibited?(block)
    block.css("div[class='post-text']").blank?
  end

  def filtered(info)
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

  def import_to_db
    self.records = records.try(:compact)
    return if records.blank?
    filter_existed
    Music.import records
    # TODO: update existed_records
  end

  def filter_existed
    existed = Music.where(title: records.map(&:title)).pluck(:title)
    return if existed.blank?
    self.existed_records = []
    records.delete_if do |h|
      if existed.include? h[:title]
        existed_records << h
        true
      end
    end
  end

  # def send_message
  #   message = {
  #     channel: "/messages/#{user.auth_token}",
  #     data: { type: :parser, status: :ok },
  #     ext: { auth_token: FAYE_TOKEN }
  #   }
  #   uri = URI.parse('http://localhost:9292/faye')
  #   Net::HTTP.post_form(uri, message: message.to_json)
  # end
end
