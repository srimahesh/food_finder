require 'restaurant'

class Guide

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
			print "> "
			user_response = gets.chomp
			# break if user_reesponse == 'quit'
		# do that action
			result = do_action(user_response)
		# repeat until user quits
		#	break if result == :quit
		end
		conclusion
	end


	def do_action(action)
		case action
		when 'list'
			puts 'listing..'
		when 'find'
			puts 'finding...'
		when 'add'
			puts 'adding..'
		when 'quit'
			return :quit
		else
			puts "\n I don't know what to do! \n"
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
