class AppleController < ApplicationController
	layout "apple.html.erb"
	
	def index
	end
	
	def welcome
		render :layout => "application"
	end
	
	def contact
	end
	
	def send_mail_to_contact
		logger.debug(params)
		name = params[:name]
		email = params[:email]
		body = params[:message]
		ContactMailer.contact_email(name, email, body).deliver
		redirect_to  "/apple/contact", notice: 'Message sent'
	end			


	def eq1
		if request.post?
			logger.debug(params)
			sorta = params[:sorta].to_i
			a = params[:param_a].to_f == 0.0 ? (10.0**-14).to_f : params[:param_a].to_f
			b = params[:param_b].to_f == 0.0 ? (10.0**-14).to_f : params[:param_b].to_f
			l = params[:param_L].to_f == 0.0 ? (10.0**-14).to_f : params[:param_L].to_f
			st= params[:param_ST].to_f== 0.0 ? (10.0**-14).to_f : params[:param_ST].to_f
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
			a = params[:param_a].to_f == 0.0 ? (10.0**-14).to_f : params[:param_a].to_f
			b = params[:param_b].to_f == 0.0 ? (10.0**-14).to_f : params[:param_b].to_f
			l = params[:param_L].to_f == 0.0 ? (10.0**-14).to_f : params[:param_L].to_f
			st= params[:param_ST].to_f== 0.0 ? (10.0**-14).to_f : params[:param_ST].to_f
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
		log_E = -0.0212338 - 1.2458245*Math.log10(l.abs())*sign(l) + 
				0.1522010*Math.log10(a.abs())*sign(a) + 
				2.0701140*Math.log10(b.abs())*sign(b) + 
				0.0279284*Math.log10(st.abs())*sign(st) + 0.1790212*( sorta == 1 ? 1.0 : 0) + 0.0703534*( sorta == 2 ? 1.0 : 0)		
		((10**log_E)<0 ? 0.0 : (10**log_E))
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
		ssc
	end

	def eq4_calc(sorta,a,b,l,st,treatment)
		log_E = -0.9516290 +
				0.4970653*Math.log10(l.abs())*sign(l) +
				0.0844496*a +
				0.4340609*Math.log10(b.abs())*sign(b) -
				0.0497866*( sorta == 1 ? 1.0 : 0) +
				0.0031467*st +
				0.1927563*(treatment == 1 ? 1 : 0) +
				0.0560170*(treatment == 2 || treatment == 6 ? 1 : 0) +
				0.0515578*(treatment == 3 || treatment == 4 ? 1 : 0) -
				0.1026755*(treatment == 5 || treatment == 7 ? 1 : 0)
		((10**log_E)<0 ? 0.0 : (10**log_E))
	end

	def eq5_calc(sorta,treatment)
		e = 5.270 -
				0.958*( sorta == 1 ? 1.0 : 0) +
				1.158*(treatment == 1 ? 1 : 0) +
				1.358*(treatment == 2 || treatment == 6 || treatment == 7 ? 1 : 0) +
				0.758*(treatment == 3 || treatment == 4 ? 1 : 0) -
				1.892*(treatment == 5  ? 1 : 0)
		
		((e)<0 ? 0.0 : (e))
	end

	def sign(a)
		(a<0 ? -1 : 1)
	end
end
