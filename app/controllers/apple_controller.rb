class AppleController < ApplicationController
	layout "apple.html.erb"
	
	def index
	end

	def eq1
		if request.post?
			logger.debug(params)
			sorta = params[:sorta].to_i
			a = params[:param_a].to_f
			b = params[:param_b].to_f
			l = params[:param_L].to_f
			st= params[:param_ST].to_f
			#Parameters:"sorta"=>"1", "param_L"=>"1", "param_a"=>"2", "param_b"=>"3", "param_ST"=>"4", "commit"=>"Calculate"}
			@rezultat = eq1_calc(sorta,a,b,l,st)			
		end
	end

	def eq2
		if request.post?
			logger.debug(params)
			sorta = params[:sorta].to_i
			formula = params[:formula].to_i
			#Parameters:"sorta"=>"1", "param_L"=>"1", "param_a"=>"2", "param_b"=>"3", "param_ST"=>"4", "commit"=>"Calculate"}
			@rezultat = eq23_calc(sorta,formula)
			@formula = formula
		end

	end

	def eq4
		if request.post?
			logger.debug(params)
			# "sorta"=>"2", "treatment"=>"3", "param_L"=>"2", "param_a"=>"4", "param_b"=>"3", "param_ST"=>"5"}
			sorta = params[:sorta].to_i
			a = params[:param_a].to_f
			b = params[:param_b].to_f
			l = params[:param_L].to_f
			st= params[:param_ST].to_f
			treatment = params[:treatment].to_i

			@rezultat = eq4_calc(sorta,a,b,l,st,treatment)

		end
	end

	def eq5
		if request.post?
			logger.debug(params)
			# "sorta"=>"2", "treatment"=>"3", "param_L"=>"2", "param_a"=>"4", "param_b"=>"3", "param_ST"=>"5"}
			sorta = params[:sorta].to_i
			treatment = params[:treatment].to_i
			@rezultat = eq5_calc(sorta,treatment)
		end		
	end

private
	def eq1_calc(sorta, a,b,l,st)
		# log(E) = -0.021 - 1,264 * log(L*) + 0.152*log(a*) + 2.070*log(b*) + 0.025*log(ST) + 0.179*(ID_GLO)+0.070*(GD_CP)
		logger.debug("#{sorta}, #{a}, #{b},#{l},#{st}")
		log_E = -0.021 - 1.264*Math.log10(l) + 0.152*Math.log10(a) + 2.070*Math.log10(b) + 0.025*Math.log10(st) + 0.179*( sorta == 1 ? 1.0 : 0) + 0.07*( sorta == 2 ? 1.0 : 0)		
		((10**log_E)<0 ? 0.0 : (10**log_E)).round(2)
	end

	def eq23_calc(sorta,formula)		
		#formula2 
		if formula == 2
			ssc =   17.57 -
					4.10*( sorta == 1 ? 1.0 : 0) -
					1.53*( sorta == 2 ? 1.0 : 0) -
					4.87*( sorta == 3 ? 1.0 : 0) -
					6.13*( sorta == 4 ? 1.0 : 0) -
					2.23*( sorta == 5 ? 1.0 : 0) -
					1.33*( sorta == 6 ? 1.0 : 0)
		else
			#formula3 (ph)
			ssc =   4.157 -
					0.710*( sorta == 1 ? 1.0 : 0) -
					0.360*( sorta == 2 ? 1.0 : 0) -
					0.210*( sorta == 3 ? 1.0 : 0) -
					0.737*( sorta == 4 ? 1.0 : 0) -
					0.517*( sorta == 5 ? 1.0 : 0) -
					0.380*( sorta == 6 ? 1.0 : 0)			
		end
		ssc.round(2)
	end

	def eq4_calc(sorta,a,b,l,st,treatment)
		log_E = -0.952 +
				0.497*Math.log10(l) +
				0.084*a +
				0.434*Math.log10(b) -
				0.050*( sorta == 1 ? 1.0 : 0) +
				0.003*st +
				0.193*(treatment == 1 ? 1 : 0) +
				0.056*(treatment == 2 || treatment == 6 ? 1 : 0) +
				0.052*(treatment == 3 || treatment == 4 ? 1 : 0) -
				0.103*(treatment == 5 || treatment == 7 ? 1 : 0)
		((10**log_E)<0 ? 0.0 : (10**log_E)).round(2)
	end

	def eq5_calc(sorta,treatment)
		e = 5.270 -
				0.958*( sorta == 1 ? 1.0 : 0) +
				1.158*(treatment == 1 ? 1 : 0) +
				1.358*(treatment == 2 || treatment == 6 || treatment == 7 ? 1 : 0) +
				0.758*(treatment == 3 || treatment == 4 ? 1 : 0) -
				1.892*(treatment == 5  ? 1 : 0)
		
		((e)<0 ? 0.0 : (e)).round(2)
	end

end
