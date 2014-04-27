require 'test/unit'
require 'language_detection'

class LanguageDetectionTest < Test::Unit::TestCase
  def test_Language_detection_is_a_module
    assert_equal LanguageDetection.class, Module
  end

  def test_error_if_empty_string_passed
    assert_raise ArgumentError do 
      LanguageDetection.detect("")
    end
  end
end