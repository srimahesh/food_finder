class Restaurant

	@@filepath = nil

	def self.filepath=(path=nil)
		# Assuming that the path argument is a relative path
		# If you want to check, you can check if the path starts with a '/'
		@@filepath = File.join(APP_ROOT, path)
	end

	attr_accessor :name, :cuisine, :price

	def self.file_exists?
		# class should know if the restaurant file exists
		if @@filepath && File.exists?(@@filepath)
			return true
		else
			return false
		end
	end

	def self.file_usable?
		return false unless @@filepath
		return false unless File.exists?(@@filepath)
		return false unless File.readable?(@@filepath)
		return false unless File.writable?(@@filepath)
		return true
	end

	def self.create_file
		# create the restaurant file
		File.open(@@filepath, 'w') unless file_exists?
		return file_usable?
	end

	def self.saved_restaurants
		# read the restaurant file
		# return instances of restaurant
	end

	def self.build_using_questions
		args = {}

	    print "\n Restaurant name: "
	    args[:name] = gets.chomp.strip

	    print "\n Cuisine name: "
	    args[:cuisine] = gets.chomp.strip

	    print "\n Average price: "
	    args[:price] = gets.chomp.strip

	    # restaurant = Restaurant.new(args)
	    return self.new(args)
	end

	### ALl Instance methods, below the CLass methods ###

	def initialize(args={})
		@name	 = args[:name]    || ""
		@cuisine = args[:cuisine] || ""
		@price 	 = args[:price]   || ""
		# Make sure all the three attributes are set before saving, to the DB
	end

	def save
		return false unless Restaurant.file_usable?
		File.open(@@filepath, 'a') do |file|
			file.puts "#{[@name, @cuisine, @price].join("\t")}\n"
		end
		return true
	end


end

