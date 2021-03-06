require "json"

require "language_detection/version"
require "language_detection/detect"
require "language_detection/parser"
require "language_detection/rank"


require "pry"

module LanguageDetection
  include LanguageDetection::Detect
end
