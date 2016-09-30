class ParserJob < ActiveJob::Base
  queue_as :parser

  # def perform(params)
  #   Parser.new(params).parse_from_fe
  # end
end
