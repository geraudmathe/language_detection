require 'test/unit'
require 'language_detection'

class LanguageDetectionTest < Test::Unit::TestCase
  def test_english_hello
    assert_equal LanguageDetection.class, Module
  end

end