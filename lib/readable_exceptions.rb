require "yaml"

module ReadableExceptions

  def self.setup(readable_msgs_file_path)
    @@error_messages = parse_input(readable_msgs_file_path)

    Exception.class_eval do
      def readable_message(context = nil)
        if ! ReadableExceptions.error_messages.has_key?(self.class.name.to_s)
          return self.message
        end

        msgs = ReadableExceptions.error_messages[self.class.name.to_s]

        if context.nil? && self.message && msgs[self.message.to_s]
          return msgs[self.message.to_s]
        end

        if ! context.nil? && msgs[context.to_s]
          return msgs[context.to_s]
        end

        self.message
      end
    end
  end

  def self.error_messages
    @@error_messages
  end

  private

  def self.parse_input(readable_msgs_file_path)
    raise(ArgumentError, "Input file must be a readable") unless (File.readable?(readable_msgs_file_path) rescue false)

    error_messages = (YAML::load(IO.read(readable_msgs_file_path))) rescue false
    raise(ArgumentError, "Input file must be valid YAML") unless error_messages

    error_messages
  end

end
