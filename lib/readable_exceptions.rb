require "yaml"

module ReadableExceptions

  def self.setup(readable_msgs_file_path)
    @@error_messages = parse_input(readable_msgs_file_path)

    Exception.class_eval do
      def readable_message(context = nil)
        ::ReadableExceptions::readable_message(self, context)
      end
    end
  end

  def self.readable_message(exception, context = nil)
    context = exception.message if context.nil?

    readable_message = message_for_context(exception.class, context)

    return exception.message if readable_message.nil?

    readable_message
  end

  private

  def self.error_messages
    @@error_messages
  end

  def self.parse_input(readable_msgs_file_path)
    raise(ArgumentError, "Input file must be a readable") unless (File.readable?(readable_msgs_file_path) rescue false)

    error_messages = (YAML::load(IO.read(readable_msgs_file_path))) rescue false
    raise(ArgumentError, "Input file must be valid YAML") unless error_messages

    error_messages
  end

  def self.message_for_context(klass, context)
    return nil if klass.nil?

    if error_messages.has_key?(klass.name.to_s) && error_messages[klass.name.to_s].has_key?(context.to_s)
      return error_messages[klass.name.to_s][context.to_s]
    end

    message_for_context(klass.superclass, context)
  end

end
