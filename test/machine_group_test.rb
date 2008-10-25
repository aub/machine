require File.dirname(__FILE__) + '/test_helper.rb'

class MachineGroupTest < Test::Unit::TestCase

  def setup
    Machine.machines.clear
  end
  
  context "defining the base machine" do
    setup do
      @group = MachineGroup.new(:article)
    end

    should "create a machine from the name of the group" do
      @group.base do |article, machine|
        article.title = 'ooooh'
      end
      a = Machine(:article)
      assert_equal 'ooooh', a.title
    end
  end

  context "creating a group with a specified class" do
    setup do
      @group = MachineGroup.new(:whoosit, :class => Article)
    end

    should "create the correct type of object and set its attributes" do
      @group.base do |article, machine|
        article.title = 'ooooh'
      end
      a = Machine(:whoosit)
      assert a.instance_of?(Article)
      assert_equal 'ooooh', a.title      
    end
  end

  context "defining the sub-machines" do
    setup do
      @group = MachineGroup.new(:article)
      @group.base do |article, machine|
        article.title = 'ooooh'
        article.rating = 3
      end
      @group.define :arts_article do |article, machine|
        article.title = 'awww'
      end
    end

    should "create a machine for the sub-machine" do
      a = Machine(:arts_article)
      assert a.instance_of?(Article)
    end
    
    should "set make the new machine an extension of the base" do
      a = Machine(:arts_article)
      assert_equal 'awww', a.title
      assert_equal 3, a.rating
    end
  end
  
  context "defining sub-machines with no base" do
    setup do
      @group = MachineGroup.new(:article)
      @group.define :arts_article do |article, machine|
        article.title = 'awww'
      end
    end

    should "create a machine for the sub-machine" do
      a = Machine(:arts_article)
      assert a.instance_of?(Article)
    end
    
    should "set the attributes correctly" do
      a = Machine(:arts_article)
      assert_equal 'awww', a.title
    end
  end
  
  context "creating a group with a specified class and no base" do
    setup do
      @group = MachineGroup.new(:whoosit, :class => Article)
      @group.define :arts_article do |article, machine|
        article.title = 'ummm'
      end
    end

    should "create the right type of object and set its attributes" do
      a = Machine(:arts_article)
      assert a.instance_of?(Article)
      assert_equal 'ummm', a.title      
    end
  end
end