module LanguageDetection  
  class Rank

    @@damping = 0.85
    @@convergence = 0.01
    def self.punct?(c);   c =~ /^[[:punct:]]$/ ? true : false end

    def self.subs(a, b)
      array = []
      raise "Array shape mismatch" if a.size != b.size
      a.map do |k, v|
        raise "Array shape mismatch" if b[k].nil?
        v - b[k]
      end
    end

    def self.mult a, b
      val = 0
      raise "Array shape mismatch" if a.size != b.size
      a.each do |k, v|
        raise "Array shape mismatch" if b[k].nil?
        val += b[k] * v unless v.nil?
      end
      val
    end


    def self.hasConverge old, _new
        total = _new.length
        diff  = self.subs(_new, old);
        (Math.sqrt(self.mult(diff, diff))/total) < @@convergence
    end

    def self.graph ngrams
      total = ngrams.length
      outlinks = {}
      graph = {}
      values = {}
      ngrams.each_with_index do |ngram, i|
        next if punct? ngram
        e = i
        while(e < total && e <=i+5) do
          break if punct?(ngrams[e])
          if (ngrams[i] == ngrams[e]) || (i > total || e > total)
            e += 1 
            next
          end
          [e, i].each do |j|
            outlinks[ngrams[j]] = 0 if outlinks[ngrams[j]].nil?
            graph[ngrams[j]] = [] if graph[ngrams[j]].nil?
            
            outlinks[ngrams[j]] +=1
            values[ngrams[j]] = 0.15
          end
          graph[ ngrams[e] ] << ngrams[i]
          graph[ ngrams[i] ] << ngrams[e]
          e += 1 
        end
      end
      {graph: graph, outlinks: outlinks, values: values}
    end

    def self.sort ngrams
      graph = self.graph ngrams
      raise "Internal error during Ranking sort" unless graph.values.all?
      return ngrams if graph[:graph].length == 0 

      damping = @@damping
      newvals = {}

      begin
        graph[:graph].each do |id, inlinks|
            pr = 0
            inlinks.each do |zid|
              pr += graph[:values][zid] / graph[:outlinks][zid]
            end
            pr = (1-damping) * damping * pr
            newvals[id] = pr
        end
        puts self.hasConverge(graph[:values], newvals)
        break if self.hasConverge(graph[:values], newvals)
        graph[:values] = newvals
      end while true
      return newvals
    end
  end
end
