class User
	attr_accessor :name, :email #field symbols
	def initialize(attributes = {}) # puts the attr in a hash table
		@name = attributes[:name] #symbol stores the attr
		@email = attributes[:email]
	end
	#method in user class takes no args
	def formatted_email
		"#{@name} <#{@email}>"
	end
end
	
