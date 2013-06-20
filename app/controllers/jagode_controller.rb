require 'fileutils'

class JagodeController < ApplicationController

	def index
		if request.post?
		#formula iz parametara
		#logger.debug(params[:param1])
		#formula
		@tac = 273.63 - 55.23*(params[:sorta].to_i) + 78.22*(params[:tip].to_i) - 14.96*params[:param_a].to_f + 12.32*params[:param_b].to_f
		@rezultat = @tac.round(2)
		end

	end

	def calculate(sorta, tip, param_a, param_b)
		(273.63 - 55.23*(sorta.to_i) + 78.22*(tip.to_i) - 14.96*(param_a.to_f) + 12.32*(param_b.to_f)).round(2)
	end

	def import
		
		@result = file_upload() if request.post?

	end

	def file_upload
	  
	  tmp = params[:file_upload][:my_file].tempfile

		require "csv"
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