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


describe ReadableExceptions do

  describe "should raise an exception when" do

    it "input file is unreadable" do
      lambda { ReadableExceptions.setup("") }.should raise_exception(ArgumentError)
    end

    it "input file is empty" do
      lambda { ReadableExceptions.setup(File.dirname(__FILE__) + "/empty.yml") }.should raise_exception(ArgumentError)
    end

  end

  it "acts on an input file that is well formed" do
    ReadableExceptions.setup(File.dirname(__FILE__) + "/example.yml")

    An::Exception.new.readable_message.should == An::Exception.new.message
    An::Exception.new.readable_message(:input_context).should == "There has been an input failure"
    An::Exception.new.readable_message(:output_context).should == "There has been an output failure"

    begin
      raise An::Exception, :input_context
    rescue Exception => e
      e.readable_message.should == "There has been an input failure"
    end

    begin
      raise An::Exception, :output_context
    rescue Exception => e
      e.readable_message.should == "There has been an output failure"
    end
  end

end
