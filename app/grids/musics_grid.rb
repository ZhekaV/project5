class MusicsGrid
  include Datagrid

  scope do
    Music
  end

  filter :title, :string
  filter :label, :enum, select: Music.pluck(:label).uniq.compact.sort, multiple: true
  filter :score, :float, range: true
  filter :votes, :integer, range: true
  # posted
  # released
  filter :viewed, :xboolean

  column(:artwork, header: 'Artwork', html: true, mandatory: true) do |music|
    link_to artwork(music), link(music), target: '_blank'
  end
  column(:title, html: true, mandatory: true) do |music|
    link_to music.title, link(music), target: '_blank'
  end
  column(:label, mandatory: true)
  column(:res_type, header: 'Res. type', mandatory: true)
  column(:score, mandatory: true)
  column(:votes, mandatory: true)
  column(:posted, mandatory: true) do |music|
    music.posted.try(:strftime, '%d/%m/%Y')
  end
  column(:released, mandatory: true) do |music|
    music.posted.try(:strftime, '%d/%m/%Y')
  end
  column(:viewed, html: true, mandatory: true) do |music|
    check_box_tag 'viewed', music.id, music.viewed
  end
end
