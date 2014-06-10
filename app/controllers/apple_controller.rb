class AppleController < ApplicationController
	layout "apple.html.erb"
	before_action :set_default_params, :only => [:r3eq2,:r5eq14]

	def set_default_params
		@length = 0.2 if params[:param_LP].nil?
		@width  = 0.2 if params[:param_WP].nil?
		@massT  = 0.2 if params[:param_MT].nil?
		@massP  = 0.464 if params[:param_MP].nil?


		@yO2tn  =  params[:param_yO2_tn].to_f
		@yO2t0  =  params[:param_yO2_t0].to_f
		@yCO2tn =  params[:param_yCO2_tn].to_f
		@yCO2t0 =  params[:param_yCO2_t0].to_f
		@tn  	=  0.5 if params[:param_tn].nil?
		@t0 	=  params[:param_t0].to_f
		@yO2in 	=  params[:param_yO2_in].to_f
		@yCO2in =  params[:param_yCO2_in].to_f
		@yO2out =  20.95  if params[:param_yO2_out].nil?
		@yCO2out=  0.03   if params[:param_yCO2_out].nil?
		@pcO2   =  633.0  if params[:param_PC_O2].nil?
		@pcCO2  =  331.0  if params[:param_PC_CO2].nil?


		@pSSC = params[:param_SSC].to_f == 0.0 ? (10.0**-14).to_f : params[:param_SSC].to_f


		@sorta 		=  1 if params[:sorta].nil?
		@treatement =  1 if params[:treatement].nil?

		@l  =  params[:param_L].to_f
		@a  =  params[:param_a].to_f
		@b  =  params[:param_b].to_f
		@sl =  params[:param_SL].to_f 
		
		logger.debug(params)
		set_post_params
	end

	def set_post_params

		if request.post?
			logger.debug(params)

			@length = length = params[:param_LP].to_f
			@width  = width  = params[:param_WP].to_f
			@massT  = massT  = params[:param_MT].to_f			
			@massP  = massP  = params[:param_MP].to_f 
			@yO2tn  = yO2tn  = params[:param_yO2_tn].to_f
			@yO2t0  = yO2t0  = params[:param_yO2_t0].to_f
			@yCO2tn = yCO2tn = params[:param_yCO2_tn].to_f
			@yCO2t0 = yCO2t0 = params[:param_yCO2_t0].to_f
			@tn  	= tn     = params[:param_tn].to_f
			@t0 	= t0     = params[:param_t0].to_f
			@yO2in 	= yO2in  = params[:param_yO2_in].to_f
			@yCO2in = yCO2in = params[:param_yCO2_in].to_f
			@yO2out = yO2out = params[:param_yO2_out].to_f
			@yCO2out= yCO2out = params[:param_yCO2_out].to_f
			@pcO2   = pcO2   = params[:param_PC_O2].to_f
			@pcCO2  = pcCO2  = params[:param_PC_CO2].to_f

			@pSSC = params[:param_SSC].to_f

			@sorta 		= sorta 		= params[:sorta].to_i
			@treatement = treatement 	= params[:treatement].to_i

			@l  = l = params[:param_L].to_f
			@a  = a = params[:param_a].to_f
			@b  = b = params[:param_b].to_f
			@sl = sl= params[:param_SL].to_f 

			d1 = "length=#{length}; width=#{width}; massP=#{massP}; yO2tn=#{yO2tn}; yO2t0=#{yO2t0}; <br>"
			d2 = "yCO2tn=#{yCO2tn}; yCO2t0=#{yCO2t0}; tn=#{tn}; t0=#{t0}; yO2in=#{yO2in};<br>"
			d3 = "yCO2in=#{yCO2in}; yO2out=#{yO2out}; yCO2out=#{yCO2out}; pcO2=#{pcO2}; pcCO2=#{pcCO2};<br>"
			d4 = "sorta=#{sorta}; treatement=#{treatement}; l=#{l}; a=#{a}; b=#{b} SL=#{sl} SSC=#{@pSSC}<br>"
			
			@debug = "---DEBUG---<br>" + d1+d2+d3+d4
		end

	end


	
	def index
	end

	def contact
		if request.post?
			logger.debug(params)
			name = params[:name]
			email = params[:email]
			body = params[:message]	
			@color="red"
			@notice = email_verify(email,body)
			return unless @notice.empty?

			ContactMailer.contact_email(name, email, body, "CAPPABLE").deliver
			@color="blue"
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

	def r3eq1

		@sorta 		=  1 if params[:sorta].nil?
		@treatement =  1 if params[:treatement].nil?
		@atmosphere =  1 if params[:atmosphere].nil?
		@l  =  params[:param_L].to_f
		@a  =  params[:param_a].to_f
		@b  =  params[:param_b].to_f
		@sl =  params[:param_SL].to_f == 0.0 ? (10.0**-14).to_f : params[:param_SL].to_f

		if request.post?
			logger.debug(params)
			#{}"sorta"=>"1", "atmosphere"=>"1", "treatment"=>"1", "param_L"=>"", "param_a"=>"", "param_b"=>"", "param_SL"=>""
			@sorta      = sorta 		= params[:sorta].to_i
			@treatement = treatement 	= params[:treatement].to_i
			@atmosphere = atmosphere	= params[:atmosphere].to_i
			@l  = l 		 	= params[:param_L].to_f
			@a  = a 			= params[:param_a].to_f
			@b  = b 			= params[:param_b].to_f
			@sl = sl= params[:param_SL].to_f == 0.0 ? (10.0**-14).to_f : params[:param_SL].to_f

			@rezultat = r3eq1_calc(l,a,b,sl,atmosphere,sorta,treatement)

		end
	end

	def r3eq2

		if request.post?
			r3eq2_calc(@length,@width,@massT,@massP,@pcO2,@pcCO2,@yO2out,@yO2in,@yO2tn,@yO2t0,@tn,@t0,@yCO2tn,@yCO2t0,@yCO2in,@yCO2out,@l,@a,@b,@sl,@sorta,@treatement)
		end

	end

	def r5eq14
		if request.post?
			r5eq14_calc(@length,@width,@massT,@massP,@pcO2,@pcCO2,@yO2out,@yO2in,@yO2tn,@yO2t0,@tn,@t0,@yCO2tn,@yCO2t0,@yCO2in,@yCO2out,@l,@a,@b,@sl,@sorta,@treatement,@pSSC)
		end
	end



private	

	def r5eq14_calc(length,width,massT,massP,pcO2,pcCO2,yO2out,yO2in,yO2tn,yO2t0,tn,t0,yCO2tn,yCO2t0,yCO2in,yCO2out,l,a,b,sl,sorta,treatement,sSC)

		vA = length * width
		logger.debug("A = #{vA}")

		
		vtotal=(10000*vA*1000)/468
		logger.debug("Vtotal = #{vtotal}")
		
		vf=vtotal-(massT*1000/massP)
		logger.debug("vf = #{vf}")
		@debug = @debug + "<br>" + "vf = #{vf}"

		pr_O2_1 = pcO2 * vA * (yO2out - yO2in)/100.0
		pr_O2_2 = (vf/100.0)*( (yO2tn - yO2t0) / (tn - t0) )
		pr_O2_3 = pr_O2_1.to_f  - pr_O2_2.to_f
		r_O2 =  pr_O2_3.to_f / massT.to_f

		@debug = @debug + "<br><br>" + "pr_O2_1 = #{pr_O2_1}"
		@debug = @debug + "<br>" + "pr_O2_2 = #{pr_O2_2}"
		@debug = @debug + "<br>" + "pr_O2_3 = #{pr_O2_3}"
		@debug = @debug + "<br>" + "r_O2 = #{r_O2}"

		pr_CO2_1 = (vf/100.0)*( (yCO2tn - yCO2t0)/(tn-t0) )
		pr_CO2_2 = pcCO2*vA*( (yCO2in - yCO2out)/100.0) 
		pr_CO2_3 = pr_CO2_1.to_f - pr_CO2_2.to_f
		r_CO2 = pr_CO2_3.to_f/massT.to_f
		@debug = @debug + "<br><br>" + "pr_CO2_1 = #{pr_CO2_1}"
		@debug = @debug + "<br>" + "pr_CO2_2 = #{pr_CO2_2}"
		@debug = @debug + "<br>" + "pr_CO2_3 = #{pr_CO2_3}"
		@debug = @debug + "<br>" + "r_CO2 = #{r_CO2}"		

		rQ=(r_CO2 / r_O2).abs()

		@debug = @debug + "<br>" + "rQ = #{rQ}"		
		
		#što ide pod logaritam moramo maknuti nule 
		a 		= a.to_f 	 == 0 ? 10**-14 : a.to_f
		sl 		= sl.to_f 	 == 0 ? 10**-14 : sl.to_f
		yO2in   = yO2in.to_f == 0 ? (10**-14).to_f : yO2in.to_f
		yCO2in  = yCO2in.to_f== 0 ? (10**-14).to_f : yCO2in.to_f
		r_O2 	= r_O2.to_f  == 0 ? 10**-14 : r_O2.to_f
		r_CO2 	= r_CO2.to_f == 0 ? 10**-14 : r_CO2.to_f
		sSC 	= sSC.to_f == 0 ? 10**-14 : sSC.to_f
		
		@debug = @debug + "<br>" + "a   = #{a}"		
		@debug = @debug + "<br>" + "sl  = #{sl}"		
		@debug = @debug + "<br>" + "yO2in  = #{yO2in}"		
		@debug = @debug + "<br>" + "yCO2in  = #{yCO2in}"	
		@debug = @debug + "<br>" + "r_CO2  = #{r_CO2}"	
		@debug = @debug + "<br>" + "r_O2  = #{r_O2}"
		@debug = @debug + "<br>" + "SSC  = #{sSC}"



		log_amb_r_O2 = 36.98799+1.27433*Math.log10(a)+5.64896*Math.log10(sl)-5.15887*Math.log10(yO2in)-11.55798*Math.log10(r_O2)-14.02838*Math.log10(sSC)
		@amb_r_O2 = log_amb_r_O2.round(2)#((10**log_amb_r_O2 )<0 ? 0.0 : (10**log_amb_r_O2)).round(2)
		
		@debug = @debug + "<br><br>" + "log_amb_r_O2 = 36.98799+1.27433*Math.log10(a)+5.64896*Math.log10(sl)-5.15887*Math.log10(yO2in)-11.55798*Math.log10(r_O2)-14.02838*Math.log10(sSC)"
		@debug = @debug + "<br>" + "log_amb_r_O2 = 36.98799+1.27433*Math.log10(#{a})+5.64896*Math.log10(#{sl})-5.15887*Math.log10(#{yO2in})-11.55798*Math.log10(#{r_O2})-14.02838*Math.log10(#{sSC})"
		@debug = @debug + "<br>" + "<strong>log_amb_r_O2  = #{log_amb_r_O2}</strong>"

		log_amb_r_CO2 = 13.489840 + 0.813521*Math.log10(a)+ 4.624729*Math.log10(sl)+5.840625*Math.log10(yCO2in)-2.571925*Math.log10(r_CO2)-13.490741*Math.log10(sSC)
		#log_amb_r_CO2 = 13.489840 + 0.813521*Math.log10(a)+ 5.840625*Math.log10(sl)-2.571925*Math.log10(yCO2in)-11.55798*Math.log10(r_CO2)-13.490741*Math.log10(sSC)
		#ostavljamo u logaritmima...
		@amb_r_CO2 = log_amb_r_CO2.round(2)#((10**log_amb_r_CO2 )<0 ? 0.0 : (10**log_amb_r_CO2 )).round(2)
		
		@debug = @debug + "<br><br>" + "log_amb_r_CO2 = 13.489840 + 0.813521*Math.log10(a)+ 4.624729*Math.log10(sl)+ 5.840625*Math.log10(yCO2in)-2.571925*Math.log10(r_CO2)-13.490741*Math.log10(sSC)"
		@debug = @debug + "<br>" + "log_amb_r_CO2 = 13.489840 + 0.813521*Math.log10(#{a})+ 4.624729*Math.log10(#{sl})- 5.840625*Math.log10(#{yCO2in})-2.571925*Math.log10(#{r_CO2})-13.490741*Math.log10(#{sSC})"
		@debug = @debug + "<br>" + "<strong>log_amb_r_CO2  = #{log_amb_r_CO2}</strong>"

		log_ebac_r_O2 = 18.130096+2.939652*Math.log10(sl)-5.687815*Math.log10(yO2in)-10.021691*Math.log10(r_O2)
		@ebac_r_O2 = log_ebac_r_O2.round(2)#((10**log_ebac_r_O2)<0 ? 0.0 : (10**log_ebac_r_O2)).round(2)

		@debug = @debug + "<br><br>" + "log_ebac_r_O2 = 18.130096+2.939652*Math.log10(sl)-5.687815*Math.log10(yO2in)-10.021691*Math.log10(r_O2)"
		@debug = @debug + "<br>" + "log_ebac_r_O2 = 18.130096+2.939652*Math.log10(#{sl})-5.687815*Math.log10(#{yO2in})-10.021691*Math.log10(#{r_O2})"
		@debug = @debug + "<br>" + "<strong>log_ebac_r_O2  = #{log_ebac_r_O2}</strong>"


		log_ebac_r_CO2 = -3.182664+2.093291*Math.log10(sl)+5.476442*Math.log10(yCO2in) -2.042063*Math.log10(r_CO2)
		@ebac_r_CO2 = log_ebac_r_CO2.round(2)#((10**log_ebac_r_CO2)<0 ? 0.0 : (10**log_ebac_r_CO2)).round(2)
		
		@debug = @debug + "<br><br>" +"log_ebac_r_CO2 = -3.182664+2.093291*Math.log10(sl)+5.476442*Math.log10(yCO2in) -2.042063*Math.log10(r_CO2)"
		@debug = @debug + "<br>" + "log_ebac_r_CO2 = -3.182664+2.093291*Math.log10(#{sl})+5.476442*Math.log10(#{yCO2in})-2.042063*Math.log10(#{r_CO2})"
		@debug = @debug + "<br>" + "<strong>log_ebac_r_CO2  = #{log_ebac_r_CO2}</strong>"

		@debug = @debug + "<br><br>" + "@amb_r_O2 = #{@amb_r_O2}"
		@debug = @debug + "<br>" + "@amb_r_CO2 = #{@amb_r_CO2}"
		@debug = @debug + "<br>" + "@ebac_r_O2 = #{@ebac_r_O2}"
		@debug = @debug + "<br>" + "@ebac_r_CO2 = #{@ebac_r_CO2}"
		@debug =""
		
		@vA 	= vA
		@vtotal = vtotal
		@vf 	= vf
		@r_O2 	= r_O2
		@r_CO2 	= r_CO2
		@rQ 	= rQ

		

	end

	
	def r3eq2_calc(length,width,massT,massP,pcO2,pcCO2,yO2out,yO2in,yO2tn,yO2t0,tn,t0,yCO2tn,yCO2t0,yCO2in,yCO2out,l,a,b,sl,sorta,treatement)
		
		#Golden Delicous
		gD = sorta == 1 ? 1 : 0
		#treatement
		notreatment = treatement == 1 ? 1 : 0
		asccia 		= treatement == 2 ? 1 : 0
		casc 		= treatement == 3 ? 1 : 0
		usndcasc	= treatement == 4 ? 1 : 0

		vA = length * width
		@debug = @debug + "<br>" + "A = #{vA}"

		
		vtotal=(10000*vA*1000)/468
		@debug = @debug + "<br>" + "Vtotal = #{vtotal}"
		
		vf=vtotal-(massT*1000/massP)
		logger.debug("vf = #{vf}")
		@debug = @debug + "<br>" + "vf = #{vf}"

		pr_O2_1 = pcO2 * vA * (yO2out - yO2in)/100.0
		pr_O2_2 = (vf/100.0)*( (yO2tn - yO2t0) / (tn - t0) )
		pr_O2_3 = pr_O2_1.to_f  - pr_O2_2.to_f
		r_O2 =  pr_O2_3.to_f / massT.to_f

		@debug = @debug + "<br><br>" + "pr_O2_1 = #{pr_O2_1}"
		@debug = @debug + "<br>" + "pr_O2_2 = #{pr_O2_2}"
		@debug = @debug + "<br>" + "pr_O2_3 = #{pr_O2_3}"
		@debug = @debug + "<br>" + "r_O2 = #{r_O2}"

		pr_CO2_1 = (vf/100.0)*( (yCO2tn - yCO2t0)/(tn-t0) )
		pr_CO2_2 = pcCO2*vA*( (yCO2in - yCO2out)/100.0) 
		pr_CO2_3 = pr_CO2_1.to_f - pr_CO2_2.to_f
		r_CO2 = pr_CO2_3.to_f/massT.to_f

		@debug = @debug + "<br>pr_CO2_1 = (vf/100.0)*( (yCO2tn - yCO2t0)/(tn-t0) )"
		@debug = @debug + "<br>pr_CO2_2 = pcCO2*vA*( (yCO2in - yCO2out)/100.0) "
		@debug = @debug + "<br>pr_CO2_3 = pr_CO2_1.to_f - pr_CO2_2.to_f"
		@debug = @debug + "<br>r_CO2 = pr_CO2_3.to_f/massT.to_f"

		@debug = @debug + "<br><br>" + "pr_CO2_1 = #{pr_CO2_1}"
		@debug = @debug + "<br>" + "pr_CO2_2 = #{pr_CO2_2}"
		@debug = @debug + "<br>" + "pr_CO2_3 = #{pr_CO2_3}"
		@debug = @debug + "<br>" + "r_CO2 = #{r_CO2}"
		
	
		
		#r_CO2=(((vf * ((yCO2tn - yCO2t0)/(tn-t0)/100))) -(pcCO2 * vA * ((yCO2in - yCO2out) / 100))) / massT
		#r_CO2=(((vf * ( ((yCO2tn-yCO2t0)/(tn-t0)/100))))-(pcCO2*vA*(yCO2in - yCO2out) / 100)) / massT		
		

		rQ=(r_CO2 / r_O2).abs()
		@debug = @debug + "<br>rQ = #{rQ}"

		dE=  54.504535 +
			-0.829271*l + 
			-0.009992*(2.71828182845904**a) + 
			0.859552*b +
			-0.224326*sl + 
			1.292377*Math.sin(r_CO2) + 
		    -2.759410*gD + 
		    42.138068*notreatment + 
		    1.149526*asccia + 
		    -1.333054*casc +
		    -0.517378*usndcasc


		    @debug = @debug +
		    "<br><br>
			dE=  54.504535 +
				-0.829271*l + 
				-0.009992*(2.71828182845904**a) + 
				0.859552*b +
				-0.224326*sl + 
				1.292377*Math.sin(r_CO2) + 
			    -2.759410*gD + 
			    42.138068*notreatment + 
			    1.149526*asccia + 
			    -1.333054*casc +
			    -0.517378*usndcasc		    
		    "
		
		@debug = @debug +
		"<br><br>
		dE=  54.504535 + <br>
			-0.829271*#{l} + <br>
			-0.009992*(2.71828182845904**#{a}) + <br>
			0.859552*#{b} + <br>
			- 0.224326*#{sl} +  <br>
			1.292377*Math.sin(#{r_CO2}) +  <br>
		    -2.759410*#{gD} +  <br>
		    42.138068*#{notreatment} +  <br>
		    1.149526*#{asccia} +  <br>
		    - 1.333054*#{casc} + <br>
		    - 0.517378*#{usndcasc} <br>
		    <br><br>

		dE=  54.504535 +
			#{-0.829271*l} + 
			#{-0.009992*(2.71828182845904**a)} + 
			#{0.859552*b} +
			#{-0.224326*sl} + 
			#{1.292377*Math.sin(r_CO2)} + 
		    #{-2.759410*gD} + 
		    #{42.138068*notreatment} + 
		    #{1.149526*asccia} + 
		    #{-1.333054*casc} +
		    #{-0.517378*usndcasc}

		"

		@debug = @debug + "<br>" + "dE = #{dE}"		
		@debug =""
		
		@vA 	= vA
		@vtotal = vtotal
		@vf 	= vf
		@r_O2 	= r_O2
		@r_CO2 	= r_CO2
		@rQ 	= rQ
		@dE 	= dE<0? 0 : dE

	end

	def r3eq1_calc(pL,a,b,sL,atmosphere,sorta,treatment)
		
		#no modification
		noMA = atmosphere == 1 ? 1 : 0
		#golden delicious
		gD = sorta == 1 ? 1 : 0
		#treatment
		notreatment = treatment == 1 ? 1 : 0
		aca 		= treatment == 2 ? 1 : 0
		caAsc 		= treatment == 3 ? 1 : 0
		usnd 		= treatment == 4 ? 1 : 0
		logger.debug(sL)
		#formula
		logde = -11.2744286 + 
				0.1266782*pL + 
				0.1244982*a + 
				0.0848380*b + 
				0.2065836*Math.log10(sL.abs())*sign(sL) + 
				0.6276360*(noMA) + 
				-0.3403982*(gD) + 
				0.3625182*(notreatment) + 
				0.2453202*(aca) + 
				-0.2475309*(caAsc) + 
				-0.1608707*(usnd)

		@debug = "l = #{pL}; a = #{a}; b = #{b}; SL = #{sL}; log(sL) = #{Math.log10(sL.abs())*sign(sL)}; GoldenDelic=#{gD}; noMA = #{noMA}; notreatment = #{notreatment}; Asorc+citrid = #{aca}, Ca-ascorb = #{caAsc}; usnd = #{usnd}; logde = #{logde}; de=#{10**logde}"
		logger.debug("logde = #{logde}")
		#result
		10**logde

	end

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
