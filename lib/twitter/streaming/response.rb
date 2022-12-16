require 'buftok'
require 'http'
require 'json'
require 'twitter/error'
require 'llhttp'

module Twitter
  module Streaming
    class Response
      # Initializes a new Response object
      #
      # @return [Twitter::Streaming::Response]
      def initialize(&block)
        @block     = block
        @parser    = LLHttp::Parser.new(self, type: :response)
        @tokenizer = BufferedTokenizer.new("\r\n")
      end

      def <<(data)
        @parser << data
      end

      def on_body(data)
        @tokenizer.extract(data).each do |line|
          next if line.empty?

          @block.call(JSON.parse(line, symbolize_names: true))
        end
      end
    end
  end
end
