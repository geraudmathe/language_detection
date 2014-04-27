module LanguageDetection  
  module Detect

    
    def self.included(base)

      base.class_eval do

        @@maxNGram = 300
        @@threshold = 0.02

        def self.parseChunk text
          ngrams =  LanguageDetection::Rank.sort @@parser.get(text)
          total  = [@@maxNGram, ngrams.size].min()
          distance = []
          
          @@data.each do |k, v|
            puts k
            distance << {lang: k, score: LanguageDetection::Rank.distance(v, ngrams, total)}
          end

          distance.sort_by { |k| k[:score]}.reverse

          #First and second language candidates are similar, we return the whole structure
          return distance if distance[0][:score] - distance[1][:score] <= @@threshold
          
          return distance[0][:lang]
          
        end

        def self.detect text
          @@parser ||= Parser.new 2, 4, 300
          file = File.read File.join(File.dirname(__FILE__), "..", "data", "languages.json")
          @@data = JSON.parse(file)["data"]
          chunks = @@parser.split text
          raise ArgumentError if chunks.empty?

          chunks.each do |chunk|
            self.parseChunk chunk
          end

          candidates = []
          distance   = []
        end
      end
    end

  end
end
