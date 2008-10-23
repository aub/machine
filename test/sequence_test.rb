require File.dirname(__FILE__) + '/test_helper.rb'

class SequenceTest < Test::Unit::TestCase

  def setup
  end
  
  def test_sequences_can_be_defined
    Machine.sequence :thing do
    end
    assert_equal 1, Machine.sequences.size
  end
  
  def test_should_increment_value
    Machine.sequence :thing do |n|
      n
    end
    assert_equal 1, Machine.sequences[:thing].next
    assert_equal 2, Machine.sequences[:thing].next
  end
  
  def test_should_be_able_to_output_strings_duh
    Machine.sequence :thing do |n|
      "article-#{n}"
    end
    assert_equal 'article-1', Machine.sequences[:thing].next
    assert_equal 'article-2', Machine.sequences[:thing].next
  end  
  
  def test_should_be_callable_through_the_machine
    Machine.sequence :thing do |n|
      "article-#{n}"
    end
    assert_equal 'article-1', Machine.next(:thing)
  end
  
  def test_should_return_nil_when_using_a_nonexistent_sequence
    assert_equal nil, Machine.next(:who)
  end
  
end