class ContactController < ApplicationController

	def index
		if request.post?
			logger.debug(params)
			name = params[:name]
			email = params[:email]
			body = params[:message]
			ContactMailer.contact_email(name, email, body, "Portal").deliver
			@notice = "Your email has been sent successfully! Thanks."
		end		
	end

end
