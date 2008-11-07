require File.dirname(__FILE__) + '/test_helper.rb'

class SequenceTest < Test::Unit::TestCase
  
  should 'allow definition of sequences' do
    Machine.sequence :thing do
    end
    assert_equal 1, Machine.sequences.size
  end
  
  should 'increment the sequence value' do
    Machine.sequence :thing do |n|
      n
    end
    assert_equal 1, Machine.sequences[:thing].next
    assert_equal 2, Machine.sequences[:thing].next
  end
  
  should 'be able to output strings' do
    Machine.sequence :thing do |n|
      "article-#{n}"
    end
    assert_equal 'article-1', Machine.sequences[:thing].next
    assert_equal 'article-2', Machine.sequences[:thing].next
  end  
  
  should 'be callable through the machine' do
    Machine.sequence :thing do |n|
      "article-#{n}"
    end
    assert_equal 'article-1', Machine.next(:thing)
  end
  
  should 'raise an exception when calling a nonexistent sequence' do
    assert_raises MachineNotFoundError do
      Machine.next(:who)
    end
  end  
end