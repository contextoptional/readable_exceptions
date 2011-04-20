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

    return exception.message if ! valid_context?(exception, context)

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
  
  def self.valid_context?(exception, context)
    if context.nil?
      exception.message.kind_of?(Hash) && exception.message.size == 1
    else
      context.kind_of?(Hash) && context.size == 1
    end
  end

  def self.message_for_context(klass, context)
    return nil if klass.nil?

    context_key = context.first[0].to_s
    sub_context_key = context.first[1].to_s

    if error_messages.has_key?(context_key) && error_messages[context_key].has_key?(klass.name.to_s) && error_messages[context_key][klass.name.to_s].has_key?(sub_context_key)
      return error_messages[context_key][klass.name.to_s][sub_context_key.to_s]
    end

    message_for_context(klass.superclass, context)
  end

end
