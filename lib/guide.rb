require 'restaurant'

class Guide
  # Can create a class variable, but using a class for illustration
  class Config
    @@actions = ['list', 'find', 'add', 'quit']
    def self.actions; @@actions; end
  end

	def initialize(path=nil)
		# locate the restaurant text file at path
		Restaurant.filepath = path
		if Restaurant.file_usable?
			puts "Found restaurant file"
		# or create a new file
		elsif Restaurant.create_file
			puts "Created restaurant file"
		# exit if create fails
		else
			puts "Exiting. \n\n"
			exit!  # Aborts the whole application
		end
	end

	def launch!
		introduction
		# action loop (Read, eval, try)
		# 	what do you want to do? (list, find, add, quit)
		result = nil
		until result == :quit 
			user_response = get_action
			# break if user_reesponse == 'quit'
		# do that action
			result = do_action(user_response)
		# repeat until user quits
		#	break if result == :quit
		end
		conclusion
	end

	def get_action
    action = nil
    # Keep asking for user input until we get a valid action
    until Guide::Config.actions.include?(action)
      puts "Actions: " + Guide::Config.actions.join(", ") if action
  		print "> "
      user_response = gets.chomp
      action = user_response.downcase.strip
    end
    return action
	end

	def do_action(action)
		case action
		when 'list'
			puts 'listing..'
		when 'find'
			puts 'finding...'
		when 'add'
			add
		when 'quit'
			return :quit
		else
			puts "\n I don't know what to do! \n"
		end
	end	

  def add
    puts "\nAdd a new Restaurant\n\n".upcase

    restaurant = Restaurant.build_using_questions

    if restaurant.save
      print "\n Restaurant saved!\n"
    else
      print "\n Save Error: couldn't save the restaurant\n"
    end
  end

	def introduction
		puts "\n\n<<< Welcome to the Food Finder >>>\n\n"
		puts "This is an interactive guide to help you find the food you crave. \n\n"
	end

	def conclusion
		puts "\n<<< Goodbye and Bon Appetit! >>> \n\n\n"
	end

end
