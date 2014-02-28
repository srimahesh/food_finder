require 'restaurant'
require 'support/string_extend'

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
			action, args = get_action
			# break if user_reesponse == 'quit'
		# do that action
			result = do_action(action, args)
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
      user_reesponse = gets.chomp
      args = user_reesponse.downcase.strip.split(' ')
      action = args.shift
    end
    return action, args
	end

	def do_action(action, args=[])
		case action
		when 'list'
			list(args)
		when 'find'
      keyword = args.shift   # Considering only the first keyword
			find(keyword)
		when 'add'
			add
		when 'quit'
			return :quit
		else
			puts "\n I don't know what to do! \n"
		end
	end	

  def add
    output_header_list("Add a new Restaurant")

    restaurant = Restaurant.build_using_questions

    if restaurant.save
      print "\n Restaurant saved!\n"
    else
      print "\n Save Error: couldn't save the restaurant\n"
    end
  end

  def list(args=[])

    sort_order = args.shift 
    # sort_order ||= "name"
    sort_order = args.shift if sort_order == "by"
    sort_order = "name" unless ['name', 'cuisine', 'price'].include?(sort_order)

    output_header_list("List Restaurants")

    restaurants = Restaurant.saved_restaurants
    restaurants.sort! do |r1, r2|
      case sort_order 
     when "name"  
      r1.name.downcase <=> r2.name.downcase
     when "cuisine"
      r1.cuisine.downcase <=> r2.cuisine.downcase
     when "price"
      r1.price.to_i <=> r2.price.to_i
      end
    end
      

    # displaying the rests
    output_restaurant_table(restaurants)
    puts "Sort using: 'list cuisine' or 'list by cuisine'"
  end

  def find(keyword="")
    output_header_list("\nFind a restaurant\n\n")
    if keyword
      restaurants = Restaurant.saved_restaurants
      found = restaurants.select do |rest|
        rest.name.downcase.include?(keyword.downcase) ||
        rest.cuisine.downcase.include?(keyword.downcase) ||
        rest.price.to_i <= keyword.to_i
      end
      output_restaurant_table(found)
    else
      puts "\n Please enter a search phrase from the list"
      puts "\nFor ex, 'find mexican', 'find mex', 'find Tamale' "
    end
  end

	def introduction
		puts "\n\n<<< Welcome to the Food Finder >>>\n\n"
		puts "This is an interactive guide to help you find the food you crave. \n\n"
	end

	def conclusion
		puts "\n<<< Goodbye and Bon Appetit! >>> \n\n\n"
	end


  private 

  def output_header_list(text)
     puts "\n#{text.upcase.center(60)}\n\n"
  end

  def output_restaurant_table(restaurants)
    print " " + "Name".ljust(30)
    print " " + "Cuisine".ljust(20)
    puts " " + "Price".ljust(6)
    puts "-" * 60
    restaurants.each do |rest|
      line =  " " + rest.name.titleize.ljust(30)
      line << " " + rest.cuisine.titleize.ljust(20)
      line << " " + rest.formated_price.ljust(6)
      puts line
    end
    puts "\nNo Listings found" if restaurants.empty?
    puts "-" * 60
  end
end
