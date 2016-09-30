module MusicsHelper
  def artwork(music)
    image_tag "http://freake.ru/#{music.artwork_url}", size: '150x150'
  end

  def link(music)
    "http://freake.ru/#{music.fe_id}"
  end
end
