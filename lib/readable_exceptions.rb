# Maps known exception types and an optional context to an human readable error message.
# Messages are defined in error_messages.yml.
#
# Examples:
#
#   begin
#     raise ::InvitesController::MissingParams, :missing_facebook_id
#   rescue StandardError => e  # rescued a known error
#     puts e.readable_message  # prints a human readable error message
#   end
#
#   begin
#     some_random_gem_method()
#   rescue StandardError => e  # rescued an uknown error
#     puts e.readable_message  # prints e.message
#   end
#
#   begin
#     moderate_facebook()
#   rescue ::Facebooker::Session::UserNotVisibleError => e
#     puts e.readable_message(:facebook_moderation)  # prints a human readable error message relevant to moderation
#   end
#
#   begin
#     publish_facebook()
#   rescue ::Facebooker::Session::UserNotVisibleError => e
#     puts e.readable_message(:facebook_publishing)  # prints a human readable error message relevant to publishing
#   end

# Avoid adding a dependency on activesupport if one doesn't already exist
begin
  require "active_support/core_ext/string/inflections"
  require "i18n"
rescue LoadError => e
  require "constantize"
end

require "yaml"

module ReadableExceptions
  extend Constantize unless String.new.respond_to?(:constantize)

  def self.setup(readable_msgs_file_path)
    error_messages = parse_input(readable_msgs_file_path)

    humanize(Exception, [])

    error_messages.each do |error_klass, msgs|
      humanize(do_constantize(error_klass), msgs)
    end
  end

  private

  def self.parse_input(readable_msgs_file_path)
    raise(ArgumentError, "Input file must be a readable") unless (File.readable?(readable_msgs_file_path) rescue false)

    error_messages = (YAML::load(IO.read(readable_msgs_file_path))) rescue false
    raise(ArgumentError, "Input file must be parsable by YAML") unless error_messages

    error_messages
  end

  def self.do_constantize(str)
    str.respond_to?(:constantize) ? str.constantize : constantize(str)
  end

  def self.humanize(klass, msgs)
    return humanize_no_msgs(klass) if msgs.empty?

    klass.class_eval(%Q{
      def readable_message(context = nil)
        result = nil
        case context
    } +

    case_for_messages(msgs) +

    %Q{
        end

        return result if result != nil

        case self.message
    }+

    case_for_messages(msgs) +

    %Q{
        else
          result = self.message
        end

        result
      end
    })
  end

  def self.humanize_no_msgs(klass)
    klass.class_eval do
      def readable_message
        return self.message
      end
    end
  end

  def self.case_for_messages(msgs)
    msgs.inject(String.new) do |s,msg|
      s += %Q{
        when :#{msg[0]}
          result = "#{msg[1]}"
      }
    end
  end

end
