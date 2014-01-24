module LanguageDetection  
  module Detect

    
    def self.included(base)

      base.class_eval do
        def self.parseChunk text
          ngrams = @@parser.get text
          rank = LanguageDetection::Rank.sort ngrams
        end

        def self.detect text
          @@parser ||= Parser.new 2, 4, 300
          chunks = @@parser.split text
          raise ArgumentError if chunks.empty?

          chunks.each do |chunk|
            self.parseChunk chunk
          end
        end
      end
    end

  end
end
