# Overview

Given a configured exception type and error context, returns a human readable error message.

# Configure it

Create your configuration file, readable_exceptions.yml.

    publishing:
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
      puts e.readable_message(:publishing => :wall_context)  # puts "We can not post to your wall"
    end

    begin
      post_to_friends_wall()
    rescue WallPostException => e
      puts e.readable_message(:publishing => :friend_wall_context)  # puts "We can not post to your friends wall"
    end

    begin
      post_to_wall()
    rescue WallPostException::IntermittentError => e
      puts e.readable_message(:publishing => :wall_context)  # puts "We can not post to your wall right now. We'll try again later."
    end

    begin
      post_to_friends_wall()
    rescue WallPostException::IntermittentError => e
      puts e.readable_message(:publishing => :friend_wall_context)  # puts "We can not post to your friends wall"
    end

    begin
      raise WallPostException, :publishing => :wall_context
    rescue StandardError => e
      puts e.readable_message  # puts "We can not post to your wall"
    end

    begin
      raise WallPostException, :publishing => :friend_wall_context
    rescue StandardError => e
      puts e.readable_message  # puts "We can not post to your friends wall"
    end

    begin
      raise WallPostException::IntermittentError, :publishing => :wall_context
    rescue StandardError => e
      puts e.readable_message  # puts "We can not post to your wall right now. We'll try again later."
    end

    begin
      raise WallPostException::IntermittentError, :publishing => :friend_wall_context
    rescue StandardError => e
      puts e.readable_message  # puts "We can not post to your friends wall"
    end

    begin
      raise UnconfiguredException, :publishing => :wall_context
    rescue StandardError => e
      puts e.readable_message  # puts e.message
    end


