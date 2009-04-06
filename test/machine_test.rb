require File.dirname(__FILE__) + '/test_helper.rb'

class MachineTest < Test::Unit::TestCase

  def setup
    Machine.machines.clear
  end

  context "building simple machines" do
    should "add a machine to the list when defined" do
      Machine.define :test, :hack => 'ack' do
      end
      assert_equal 1, Machine.machines.size
    end

    should "set proper machine variables when creating" do
      Machine.define :testo, :class => Article do
      end
      assert_not_nil Machine.machines[:testo]
    end
  end
  
  context "using machines" do
    should "build an instance of the object" do
      Machine.define :article do
      end
      assert Machine.build(:article).instance_of?(Article)
    end

    should "build an instance of the provided class" do
      Machine.define :something, :class => Article do
      end
      assert Machine.build(:something).instance_of?(Article)
    end

    should "set default attributes on the built object" do
      Machine.define :thing, :class => Article do |article, machine|
        article.title = 'aha'
      end
      assert_equal 'aha', Machine.build(:thing).title
    end

    should "allow overriding of default attributes" do
      Machine.define :thing, :class => Article do |article, machine|
        article.title = 'aha'
      end
      assert_equal 'ooooh', Machine.build(:thing, :title => 'ooooh').title    
    end

    should "only replace the attributes that are passed" do
      Machine.define :thing, :class => Article do |article, machine|
        article.title = 'aha'
        article.rating = 123
      end
      assert_equal 123, Machine.build(:thing, :title => 'ooooh').rating
    end

    should "not save records with build" do
      Machine.define :thing, :class => Article do |article, machine|
        article.title = 'aha'
      end
      assert Machine.build(:thing).new_record?    
    end

    should "save records with build!" do
      Machine.define :thing, :class => Article do |article, machine|
        article.title = 'aha'
      end
      assert !Machine.build!(:thing).new_record?
    end
    
    should "allow redefinition of a machine" do
      Machine.define :article do |article, machine|
        article.title = 'aha'
      end

      Machine.define :article do |article, machine|
        article.title = 'oho'
      end
      assert_equal 'oho', Machine.build(:article).title
    end
    
    should 'raise an exception when using a machine that doesn\'t exist' do
      assert_raises MachineNotFoundError do
        Machine.build(:i_can_has_exception)
      end
    end
  end
  
  context "with objects that are not active record" do
    setup do
      Machine.define :non_model do |nonmodel, machine|
        nonmodel.name = 'hoo'
      end      
    end

    should "build the object correctly" do
      assert_equal 'hoo', Machine.build(:non_model).name      
    end
    
    should "not freak out when calling build! with non-activerecord objects" do
      assert_nothing_raised do
        Machine.build!(:non_model).name
      end
    end
  end
      
  context "with associations" do
    setup do
      Machine.define :publication do |publication, machine|
        publication.name = 'booya'
      end
      
      Machine.define :comment do |comment, machine|
        comment.data = 'dsfsdf'
      end

      Machine.define :article do |article, machine|
        article.comments = [machine.comment, machine.comment]
        article.publication = machine.publication
      end
    end

    should "build associated records" do
      assert_equal 2, Machine.build(:article).comments.size
      assert Machine.build(:article).comments[0].instance_of?(Comment)
    end
    
    should "allow passing replacement attributes" do
      Machine.define :article do |article, machine|
        article.comments = [machine.comment(:data => 'nice article'), machine.comment(:data => 'bad article')]
      end
      assert_equal ['nice article', 'bad article'].sort, Machine.build(:article).comments.map { |c| c.data }.sort
    end
    
    should "not save associated objects when using build" do
      assert Machine.build(:article).comments[0].new_record?
    end
    
    should "save associated objects when using build!" do
      assert !Machine.build!(:article).comments[0].new_record?
      assert !Machine.build!(:article).publication.new_record?
    end
  end
  
  context "extending existing factories" do
    setup do
      Machine.define :old_article, :class => Article do |article, machine|
        article.title = 'old'
        article.rating = 12
      end
      
      Machine.define :new_article, :class => Article, :extends => :old_article do |article, machine|
        article.title = 'new'
        article.author = 'Joe Six Pack'
      end
    end

    should "create a new model with the correct attributes" do
      article = Machine.build(:new_article)
      assert_equal 'new', article.title
      assert_equal 12, article.rating
      assert_equal 'Joe Six Pack', article.author
    end
    
    should "work properly with multiple layers of extensions" do
      Machine.define :newer_article, :class => Article, :extends => :new_article do |article, machine|
        article.rating = 13
      end
      
      article = Machine.build(:newer_article)
      assert_equal 'new', article.title
      assert_equal 13, article.rating
      assert_equal 'Joe Six Pack', article.author
    end
  end
  
  context "loading default paths" do
    Machine.definition_file_paths.each do |file|
      should "automatically load definitions from #{file}.rb" do
        Machine.stubs(:require).raises(LoadError)
        Machine.expects(:require).with(file)
        Machine.find_definitions
      end
    end

    should "only load the first set of machines detected" do
      first, second, third = Machine.definition_file_paths
      Machine.expects(:require).with(first).raises(LoadError)
      Machine.expects(:require).with(second)
      Machine.expects(:require).with(third).never
      Machine.find_definitions
    end
  end

  context "using the helper method" do
    setup do
      Machine.define :article do |article, machine|
        article.title = 'aha'
      end      
    end

    should "apply machines correctly" do
      assert Machine(:article).instance_of?(Article)
    end
    
    should "set the attributes" do
      assert_equal 'aha', Machine(:article).title
    end
    
    should "allow replacement attributes" do
      assert_equal 'ooh', Machine(:article, :title => 'ooh').title
    end
    
    should "not save the object" do
      assert Machine(:article).new_record?
    end
  end
  
  context "applying a machine to an existing object" do
    setup do
      Machine.define :article do |article, machine|
        article.title = 'aha'
      end
      @article = Article.new(:title => 'old')
    end

    should "update the object's attributes" do
      Machine.apply_to(:article, @article)
      assert_equal 'aha', @article.title
    end
    
    should "accept replacement attributes" do
      Machine.apply_to(:article, @article, :title => 'new')
      assert_equal 'new', @article.title
    end
    
    should "not save the object" do
      Machine.apply_to(:article, @article)
      assert @article.new_record?
    end
  end
  
  context "group definition" do
    should "yield a Group instance" do
      thing = nil
      Machine.define_group :user do |group|
        thing = group
      end
      assert thing.kind_of?(MachineGroup)
    end
  end
  
  context 'using sequences' do
    setup do
      Machine.sequence :title do |n|
        "title-#{n}"
      end
      Machine.define :article do |article, machine|
        article.title = machine.next(:title)
      end
    end

    should 'be able to set values using the sequence' do
      assert_equal 'title-1', Machine(:article).title
    end
  end
  
  context 'with blocks on create' do
    setup do
      Machine.define :article do |article, machine|
        article.title = 'aha'
      end
    end

    should 'use a passed block in create to initialize objects' do
      article = Machine.build(:article) do |article|
        article.title = 'heck'
      end
      assert_equal 'heck', article.title
    end

    should 'use a passed block when creating with build!' do
      article = Machine.build!(:article) do |article|
        article.title = 'fun'
        assert article.new_record?
      end
      assert_equal 'fun', article.title
      assert !article.new_record?
    end

    should 'use the block in the shorthand version of build' do
      article = Machine(:article) do |article|
        article.title = 'another one'
      end
      assert_equal 'another one', article.title
      assert article.new_record?
    end
  end
end
