require 'test/unit'
require 'time'
require File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib', 'time_ago'))

class TimeAgoTest < Test::Unit::TestCase
  
  def setup
    ::TimeAgo.instance_eval do
      def self.now
        Time.parse("08-FEB-2013 14:33:00")
      end
    end
  end
  
  def teardown
    ::TimeAgo.instance_eval do
      def self.now
        Time.now
      end
    end    
  end
  
  def test_in_minutes_should_work_for_even_minutes
    assert_equal 5, TimeAgo::in_minutes(Time.parse("08-FEB-2013 14:28:00"))
  end
  
  def test_in_minutes_should_give_exact_decimal
    assert_equal 4.5, TimeAgo::in_minutes(Time.parse("08-FEB-2013 14:28:30"))
  end
  
  def test_in_minutes_should_give_decimal_below_one_when_only_seconds_have_elapsed
    assert_equal 1.0/3.0, TimeAgo::in_minutes(Time.parse("08-FEB-2013 14:32:40"))
  end
  
  def test_in_words_should_give_minutes_when_below_one_hour
    assert_equal '5 minutes', TimeAgo::in_words(Time.parse("08-FEB-2013 14:28:00"))
  end
  
  def test_in_words_should_round_up_to_one_minute_when_only_seconds_have_elapsed
    assert_equal '1 minutes', TimeAgo::in_words(Time.parse("08-FEB-2013 14:32:40"))
  end
  
  def test_in_words_should_list_about_an_hour_during_the_first_hour
    assert_equal 'about an hour', TimeAgo::in_words(Time.parse("08-FEB-2013 13:33:00"))
    assert_equal 'about an hour', TimeAgo::in_words(Time.parse("08-FEB-2013 13:02:00"))
    assert_equal 'about an hour', TimeAgo::in_words(Time.parse("08-FEB-2013 12:33:00"))
  end
  
  def test_in_words_should_show_hours_after_hour_two
    assert_equal '2 hours', TimeAgo::in_words(Time.parse("08-FEB-2013 12:32:59"))
    assert_equal '5 hours', TimeAgo::in_words(Time.parse("08-FEB-2013 09:32:00"))
    assert_equal '29 hours', TimeAgo::in_words(Time.parse("07-FEB-2013 09:32:00"))
    assert_equal '53 hours', TimeAgo::in_words(Time.parse("06-FEB-2013 09:32:00"))
  end
  
end