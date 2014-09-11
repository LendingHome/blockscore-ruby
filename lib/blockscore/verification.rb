module BlockScore
	class Verification < Restful
		PATH = '/verifications'
		
		# Public: Creates a new verification
		#
		# options = {} -
		#
		# Returns the duplicated String.
		def self.create(options = {})
			req :post, PATH, options
		end

		# Public: Duplicate some text an arbitrary number of times.
		#
		# options = {} -
		#
		# Returns the duplicated String.
		def self.retrieve(options = {})
			req :get, "#{PATH}/#{id.to_s}", options
		end
		
		# Public: Duplicate some text an arbitrary number of times.
		#
		# options = {} -
		#
		# Returns the duplicated String.
		def self.all(options = {})
			req :get, PATH, options
		end
	end
end