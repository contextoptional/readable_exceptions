# Overview

Given a configured exception type and error context, returns a human readable error message.

# Configure it

Create your configuration file, readable_exceptions.yml.

    "WallPostException":
      wall_context: "We can not post to your wall"
      friend_wall_context: "We can not post to your friends wall"

    "WallPostException::IntermittentError":
      wall_context: "We can not post to your wall right now. We'll try again later."

WallPostException::IntermittentError is a child class of WallPostException.

# Use it

    ReadableExceptions.setup(File.dirname(__FILE__) + "/readable_exceptions.yml")

    begin
      post_to_wall()
    rescue WallPostException => e
      puts e.readable_message(:wall_context)  # puts "We can not post to your wall"
    end

    begin
      post_to_friends_wall()
    rescue WallPostException => e
      puts e.readable_message(:friend_wall_context)  # puts "We can not post to your friends wall"
    end

    begin
      post_to_wall()
    rescue WallPostException::IntermittentError => e
      puts e.readable_message(:wall_context)  # puts "We can not post to your wall right now. We'll try again later."
    end

    begin
      post_to_friends_wall()
    rescue WallPostException::IntermittentError => e
      puts e.readable_message(:friend_wall_context)  # puts "We can not post to your friends wall"
    end

    begin
      raise WallPostException, :wall_context
    rescue StandardError => e
      puts e.readable_message  # puts "We can not post to your wall"
    end

    begin
      raise WallPostException, :friend_wall_context
    rescue StandardError => e
      puts e.readable_message  # puts "We can not post to your friends wall"
    end

    begin
      raise WallPostException::IntermittentError, :wall_context
    rescue StandardError => e
      puts e.readable_message  # puts "We can not post to your wall right now. We'll try again later."
    end

    begin
      raise WallPostException::IntermittentError, :friend_wall_context
    rescue StandardError => e
      puts e.readable_message  # puts "We can not post to your friends wall"
    end

    begin
      raise UnconfiguredException, :wall_context
    rescue StandardError => e
      puts e.readable_message  # puts e.message
    end


