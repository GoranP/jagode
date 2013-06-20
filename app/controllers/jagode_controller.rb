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

	def update
	end
end