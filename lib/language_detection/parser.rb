module LanguageDetection
  class Parser
    @@regex = /[ \r\n\t_\.\-0-9]+/

    def initialize min, max, length

    end

    def split text, length=200
      text = text.downcase.gsub @@regex, "_"
      chunks = text.chars.each_slice(length).map(&:join)
      chunks.pop if chunks.size > 1 && chunks.last.length < 100
      chunks
    end

    def get text, limit = -1
      text = text.downcase.gsub @@regex, "_"
      text.slice!( 0, limit) if limit> 0
      min = 2
      max = 4
      length = text.size
      result = (min..max).map do |len|
        (0..length).map do  |i|
          text.slice i, len
        end
      end
      result.flatten.reject{ |c| c.empty? }
    end
  end
end