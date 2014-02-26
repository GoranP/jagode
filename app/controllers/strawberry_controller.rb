require 'fileutils'
require "csv"

class StrawberryController < ApplicationController
	layout "strawberry.html.erb"

	def index
	end

	def contact
		if request.post?
			logger.debug(params)
			name = params[:name]
			email = params[:email]
			body = params[:message]
			ContactMailer.contact_email(name, email, body, "TAC").deliver
			@notice = "Your email has been sent successfully! Thanks."
		end
	end


	def eq1
		if request.post?
			#formula iz parametara
			#logger.debug(params[:param1])
			#formula
			@tac = 273.63 - 55.23*(params[:sorta].to_i) + 78.22*(params[:tip].to_i) - 14.96*params[:param_a].to_f + 12.32*params[:param_b].to_f
			@rezultat = @tac>0 ? @tac.round(2) : 0
		end
	end

	def calculate(sorta, tip, param_a, param_b)
		retval=(273.63 - 55.23*(sorta.to_i) + 78.22*(tip.to_i) - 14.96*(param_a.to_f) + 12.32*(param_b.to_f)).round(2)
		retval = 0 if retval < 0
		retval
	end

	def import
		
		@result = file_upload() if request.post?

	end

	def file_upload
	  
	  	return if params[:file_upload].nil? ||  params[:file_upload][:my_file].nil?
		tmp = params[:file_upload][:my_file].tempfile	 	

		parsed_file = CSV.read(tmp, { :col_sep => "\t" })
		
		@result =[]

		parsed_file.each{|row|
			next if row.nil? || row[0].nil? || [0][0].nil? || row[0][0]=='#'
			result = calculate(row[0],row[1],row[2],row[3])
			@result << [result,row[0],row[1],row[2],row[3]]
			#logger.debug("TAC = #{result} -> Cultivars = #{row[0]} | Form = #{row[2]} | A = #{row[2]} | B = #{row[3]}")
		}
		@result

	end

	def update
	end
end