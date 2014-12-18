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
            
            distance << {lang: k, score: LanguageDetection::Rank.distance(v, ngrams, total)}
          end
          sorted_distances = distance.sort_by { |k| k[:score]}.reverse

          #First and second language candidates are similar, we return the whole structure
          return sorted_distances if sorted_distances[0][:score] - sorted_distances[1][:score] <= @@threshold
          
          return sorted_distances[0][:lang]
          
        end

        def self.detect text
          @@parser ||= Parser.new 2, 4, 300
          file = File.read File.join(File.dirname(__FILE__), "..", "data", "languages.json")
          @@data = JSON.parse(file)["data"]
          chunks = @@parser.split text
          raise ArgumentError if chunks.empty?

          results = []

          candidates = []
          distance   = []

          chunks.each do |chunk| 
            chunk_language = self.parseChunk(chunk)
            return chunk_language if chunk_language.is_a? String
            results << self.parseChunk(chunk)
          end

          #debug 
          puts "multi-chunks #{results.length}" if results.length > 0

          results.each do |result|

            candidates << result if result.is_a? String
            next

            result.each do |data|
              distance[data[:lang]] = {lang: data[:lang], score: 0} if distance[data[:lang]].nil?
              distance[data[:lang]][:score] += data[:score]
            end
          end
          if candidates.count > 0
            candidates = candidates.inject(Hash.new(0)) { |total, e| total[e] += 1 ;total}
            candidates.sort_by! {|_key, value| value}
            candidates.reverse!
            # if (current($candidates) != array_sum(array_splice($candidates, 0, 2))/2) {
            #     /* the first *is* more than the second */
            #     return key($candidates);
            # }
            raise NotImplementedError
          end

          "implement"
        # $distance = array_map(function($v) use ($results) {
        #     $v['score'] /= count($results);
        #     return $v;
        # }, $distance);
        # $distance = array_values($distance);
        # usort($distance, function($a, $b) {
        #     return $a['score'] > $b['score'] ? -1 : 1;
        # });
        # if ($distance[0]['score'] - $distance[1]['score'] <= $this->threshold) {
        #     /** We're not sure at all, we return the whole array then */
        #     return $distance;
        # }
        
        # return $distance[0]['lang'];
        end
      end
    end

  end
end
