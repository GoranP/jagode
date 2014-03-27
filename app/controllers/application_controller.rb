class ApplicationController < ActionController::Base
  protect_from_forgery

	def email_verify(email, body)
		
		if email.empty? || body.empty?		
			return "Message cannot be sent! Required email or body fields are missing." 
		end

		if !(/@/ =~ email)		
			return "Message cannot be sent! Email is invalid." 
		end
		""
	end
  
end
