class AppleController < ApplicationController
	layout "apple.html.erb"
	
	def index
	end

	def contact
		if request.post?
			logger.debug(params)
			name = params[:name]
			email = params[:email]
			body = params[:message]	

			@notice = email_verify(email,body)
			return unless @notice.empty?

			ContactMailer.contact_email(name, email, body, "CAPPABLE").deliver
			@notice = "Your email has been sent successfully! Thanks."
		end		
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

	def st
		if request.post?
			logger.debug(params)

			sorta 		= params[:sorta].to_i
			treatement 	= params[:treatement].to_i
			l 		 	= params[:param_L].to_f
			a 			= params[:param_a].to_f
			b 			= params[:param_b].to_f
			c 			= params[:param_c].to_f
			pH			= params[:param_ph].to_f
			ssc			= params[:param_ssc].to_f
			seval		= params[:param_seval].to_f == 0.0 ? (10.0**-14).to_f : params[:param_seval].to_f
			tx 			= params[:param_tx].to_f == 0.0 ? (10.0**-14).to_f : params[:param_tx].to_f
			delta_e		= params[:param_delta_e].to_f == 0.0 ? (10.0**-14).to_f : params[:param_delta_e].to_f
			legal		= params[:param_legal].to_i
			ebac		= params[:param_ebac].to_f == 0.0 ? (10.0**-14).to_f : params[:param_ebac].to_f
			amb			= params[:param_amb].to_f == 0.0 ? (10.0**-14).to_f : params[:param_amb].to_f
						
			@rezultat = st_calc(l,a,b,c,pH,ssc,seval,tx,delta_e,sorta,treatement)			

			st = legal == 0 ? st_legal(ebac) : st_spoiled(amb)

			@rezultat_delta = sign(st - @rezultat) < 0 ? 0 : (st - @rezultat)

		end		
	end

private	

	def st_calc(l,a,b,c,pH,ssc,seval,tX,dE,gD,noTR)

		rez = 	139.22516 +
				4.44313*gD + 
				2.46953*noTR +
				-0.19282*l +
				1.18667*a +
				10.12652*b +
				-10.19815*c +
				-20.15348*pH +
				-1.38471*ssc +
				-7.19258*Math.log10(seval.abs())*sign(seval) +
				-4.48949*Math.log10(tX.abs())*sign(tX) +
				1.16645*Math.log10(dE.abs())*sign(dE) 		

		sign(rez) < 0 ? 0 : rez

	end

	def st_spoiled (amb)
		-3.90 + 2.07*Math.log10(amb.abs())*sign(amb)		
	end

	def st_legal(ebac)
		-0.66 + 3.52*Math.log10(ebac.abs())*sign(ebac)
	end


	def eq1_calc(sorta, a,b,l,st)		
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
