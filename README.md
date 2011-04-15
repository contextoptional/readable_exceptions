# Overview

Given a configured exception type and error context, returns a human readable error message.

# Set it up

    ReadableExceptions.setup(File.dirname(__FILE__) + "/examples.yml")

See spec/example.yml for an example of the input file format.

# Use it

    begin
      raise ::InvitesController::MissingParams, :missing_facebook_id
    rescue StandardError => e  # rescued a known error
      puts e.readable_message  # prints a human readable error message
    end

    begin
      some_random_gem_method()
    rescue StandardError => e  # rescued an uknown error
      puts e.readable_message  # prints e.message
    end

    begin
      moderate_facebook()
    rescue ::Facebooker::Session::UserNotVisibleError => e
      puts e.readable_message(:facebook_moderation)  # prints a human readable error message relevant to moderation
    end

    begin
      publish_facebook()
    rescue ::Facebooker::Session::UserNotVisibleError => e
      puts e.readable_message(:facebook_publishing)  # prints a human readable error message relevant to publishing
    end
