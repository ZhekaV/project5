class ParserJob < SidekiqJob
  queue_as :parser

  def perform(params)
    Music.new(params).parse
  end
end
