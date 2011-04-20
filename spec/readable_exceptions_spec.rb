require "spec_helper"


# Declare classes that appear in yml input files
class An
class Exception < Exception
end
end

class Another
class Exception < Exception
end
end

class ChildException < Another::Exception
end

class YetAnother
class Exception < Exception
end
end


describe ReadableExceptions do

  describe "should raise an exception when" do

    it "input file is unreadable" do
      lambda { ReadableExceptions.setup("") }.should raise_exception(ArgumentError)
    end

    it "input file is empty" do
      lambda { ReadableExceptions.setup(File.dirname(__FILE__) + "/empty.yml") }.should raise_exception(ArgumentError)
    end

  end

  describe "parses the input file" do

    before :each do
      ReadableExceptions.setup(File.dirname(__FILE__) + "/example.yml")
    end

    describe "returns the exception's message when" do

      it "has no readable message context" do
        e = An::Exception.new("test")
        e.readable_message.should == "test"
      end
      
      it "the exception type does not have a readable message defined" do
        e = YetAnother::Exception.new("test")
        e.readable_message(:unknown => :context).should == "test"
      end

      it "the exception has a readable message defined but not in this context" do
        e = An::Exception.new("test")
        e.readable_message(:foo => :context).should == "test"
        e = An::Exception.new("test")
        e.readable_message(:baz => :input_context).should == "test"        
      end

      it "neither the exception nor its parents have readable message defined for this context" do
        e = ChildException.new("test")
        e.readable_message(:unknown => :context).should == "test"
      end

    end

    describe "returns the exception's readable message when" do

      it "readable_message is called" do
        An::Exception.new.readable_message.should == An::Exception.new.message
        An::Exception.new.readable_message(:foo => :input_context).should == "There has been an input failure"
        An::Exception.new.readable_message(:foo => :output_context).should == "There has been an output failure"
        Another::Exception.new.readable_message(:bar => :print_context).should == "We can not print right now"
        ChildException.new.readable_message(:bar => :print_context).should == "We can print right now"
        Another::Exception.new.readable_message(:bar => :post_context).should == "We can not post right now"
        ChildException.new.readable_message(:bar => :post_context).should == "We can not post right now"
      end

      it "an exception is instantiated with its message set to a readable message key" do
        begin
          raise An::Exception, :foo => :input_context
        rescue Exception => e
          e.readable_message.should == "There has been an input failure"
        end

        begin
          raise An::Exception, :foo => :output_context
        rescue Exception => e
          e.readable_message.should == "There has been an output failure"
        end

        begin
          raise Another::Exception, :bar => :print_context
        rescue Exception => e
          e.readable_message.should == "We can not print right now"
        end

        begin
          raise ChildException, :bar => :print_context
        rescue Exception => e
          e.readable_message.should == "We can print right now"
        end

        begin
          raise Another::Exception, :bar => :post_context
        rescue Exception => e
          e.readable_message.should == "We can not post right now"
        end

        begin
          raise ChildException, :bar => :post_context
        rescue Exception => e
          e.readable_message.should == "We can not post right now"
        end
      end

    end

  end

end
