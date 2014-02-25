class ContactController < ApplicationController

	def index
	end

	def send_mail_to_contact
		logger.debug(params)
		name = params[:name]
		email = params[:email]
		body = params[:message]
		ContactMailer.contact_email(name, email, body, "Portal").deliver
		redirect_to  "/contact", notice: 'Message sent'
	end			

end
