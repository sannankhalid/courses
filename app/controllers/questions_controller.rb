class QuestionsController < ApplicationController

#the one below is for the generation of questions. 
	def index
 		current_user_id = current_user.id
 		if params[:step].present? && [3,4,5].include?(params[:step].to_i) 			 			
 			@answers = Answer.joins("INNER JOIN algorithms on algorithms.id = answers.question_id").where("answers.user_id = #{current_user_id}").select("algorithms.trait,avg(answers.answer) AS answer_avg").order("avg(answers.answer)").group("algorithms.trait").limit(3)
 			@answers = @answers.reverse
 			if [3,4].include?(params[:step].to_i) 				
 				if @answers.present?
 					@questions = Algorithm.find_by_sql("SELECT t.id, question, trait FROM (SELECT (SELECT id FROM algorithms WHERE trait = "+@answers.first.trait.to_s+" ORDER BY RANDOM() LIMIT 1) id FROM algorithms t WHERE t.id NOT IN ("+Answer.select('question_id').where("user_id = #{current_user_id}").map(&:question_id).join(',')+") GROUP BY trait  LIMIT 1) q JOIN algorithms t ON q.id = t.id ") 					
 					@questions += Algorithm.find_by_sql("SELECT t.id, question, trait FROM (SELECT (SELECT id FROM algorithms WHERE trait = "+@answers.first.trait.to_s+" AND id != #{@questions[0].id} ORDER BY RANDOM() LIMIT 1) id FROM algorithms t WHERE t.id NOT IN ("+Answer.select('question_id').where("user_id = #{current_user_id}").map(&:question_id).join(',')+","+@questions[0].id.to_s+") GROUP BY trait  LIMIT 1) q JOIN algorithms t ON q.id = t.id ") 					
 					traits = @answers.map(&:trait)
 					traits.delete_at(0)
 					@questions += Algorithm.find_by_sql("SELECT t.id, question, trait FROM (SELECT (SELECT id FROM algorithms WHERE trait = t.trait AND trait IN ("+traits.join(",")+") ORDER BY RANDOM() LIMIT 1) id FROM algorithms t WHERE t.id NOT IN ("+Answer.select('question_id').where("user_id = #{current_user_id}").map(&:question_id).join(',')+") GROUP BY trait ) q JOIN algorithms t ON q.id = t.id ")
 				end
 			else
 				redirect_to question_path(1,:trait => @answers.first(2).map { |e| e.trait }) 			 			
 			end 			 			
 		elsif params[:step].present? && params[:step].to_i == 2
 			@questions = Algorithm.find_by_sql("SELECT t.id, question, trait FROM (SELECT (SELECT id FROM algorithms WHERE trait = t.trait ORDER BY RANDOM() LIMIT 1) id FROM algorithms t WHERE t.id NOT IN ("+Answer.select('question_id').where("user_id =#{current_user_id}").map(&:question_id).join(',')+") GROUP BY trait ) q JOIN algorithms t ON q.id = t.id ")
 		else
	 		params[:step] ||= 1
	 		@questions = Algorithm.find_by_sql("SELECT t.id, question, trait FROM (SELECT (SELECT id FROM algorithms WHERE trait = t.trait ORDER BY RANDOM() LIMIT 1) id FROM algorithms t GROUP BY trait) q JOIN algorithms t ON q.id = t.id")			
		end
 	end

	# working mysql queries
 	# def index
 	# 	current_user_id = current_user.id
 	# 	if params[:step].present? && [3,4,5].include?(params[:step].to_i) 			 			
 	# 		@answers = Answer.joins("INNER JOIN algorithms on algorithms.id = answers.question_id").where("answers.user_id = #{current_user_id}").select("algorithms.trait,avg(answers.answer) AS answer_avg").order("avg(answers.answer)").group("algorithms.trait").limit(3)
 	# 		if [3,4].include?(params[:step].to_i) 				
 	# 			if @answers.present?
 	# 				@questions = Algorithm.find_by_sql("SELECT t.id, question, trait FROM (SELECT (SELECT id FROM algorithms WHERE trait = "+@answers.first.trait.to_s+" ORDER BY RANDOM() LIMIT 1) id FROM algorithms t WHERE t.id NOT IN ("+Answer.select('question_id').where("user_id = #{current_user_id}").map(&:question_id).join(',')+") GROUP BY trait LIMIT 2) q JOIN algorithms t ON q.id = t.id ") 					
 	# 				traits = @answers.map(&:trait)
 	# 				traits.delete_at(0)
 	# 				@questions += Algorithm.find_by_sql("SELECT t.id, question, trait FROM (SELECT (SELECT id FROM algorithms WHERE trait = t.trait AND trait IN ("+traits.join(",")+") ORDER BY RANDOM() LIMIT 1) id FROM algorithms t WHERE t.id NOT IN ("+Answer.select('question_id').where("user_id = #{current_user_id}").map(&:question_id).join(',')+") GROUP BY trait ) q JOIN algorithms t ON q.id = t.id ")
 	# 			end
 	# 		else
 	# 			redirect_to question_path(1,:trait => @answers.pluck(:trait).first(2)) 			 			
 	# 		end 			 			
 	# 	elsif params[:step].present? && params[:step].to_i == 2
 	# 		@questions = Algorithm.find_by_sql("SELECT t.id, question, trait FROM (SELECT (SELECT id FROM algorithms WHERE trait = t.trait ORDER BY RANDOM() LIMIT 1) id FROM algorithms t WHERE t.id NOT IN ("+Answer.select('question_id').where('user_id = 1').map(&:question_id).join(',')+") GROUP BY trait ) q JOIN algorithms t ON q.id = t.id ")
 	# 	else
	 # 		params[:step] ||= 1
	 # 		@questions = Algorithm.find_by_sql("SELECT t.id, question, trait FROM (SELECT (SELECT id FROM algorithms WHERE trait = t.trait ORDER BY RANDOM() LIMIT 1) id FROM algorithms t GROUP BY trait) q JOIN algorithms t ON q.id = t.id")			
		# end
 	# end

 	def create
 		if params[:answer].present?
 			if params[:answer].length == 6 && [1,2].include?(params[:step].to_i)
	 			params[:answer].each do |key,value|
	 				@answer = Answer.create(:answer=>value ,:question_id=>key ,:user_id=>current_user.id)
	 			end
	 			redirect_to questions_path( :step => params[:step].to_i+1 ) 
	 		elsif params[:answer].length == 4 && [3,4].include?(params[:step].to_i) 
	 			params[:answer].each do |key,value|
	 				@answer = Answer.create(:answer=>value ,:question_id=>key ,:user_id=>current_user.id)
	 			end
	 			redirect_to questions_path( :step => params[:step].to_i+1 )
	 		else
	 			redirect_to questions_path
	 		end
 		else
	 		redirect_to questions_path
 		end
 	end


 	def show
 		#Anu Comments: On finishing the Questions trait will be recieved here on params[:trait]
 		flash[:notice] = "Courses Recommended For You"
 		if params[:trait].present?
	 		trait1 = params[:trait][0].to_i
	 		trait2 = params[:trait][1].to_i
	 	else
 		#Anu Comments: On finishing the Questions ,any time clicking on recommendations will reach here
 			@answers = Answer.joins("INNER JOIN algorithms on algorithms.id = answers.question_id").where("answers.user_id = #{current_user.id}").select("algorithms.trait,avg(answers.answer) AS answer_avg").order("avg(answers.answer)").group("algorithms.trait").limit(3)
 			trait1 = @answers[0].attributes["trait"].to_i
 			trait2 = @answers[1].attributes["trait"].to_i
	 	end	
	 	flash[:notice] = "Your major personality trait is #{Algorithm::PERSONALITY_TYPE[trait1]} & minor personality trait is #{Algorithm::PERSONALITY_TYPE[trait2]}" 	
 		#Srinath Comments: Based on the stored answers finding the sections.It will be immediately from questionare or recommendations.
		@sections = Section.paginate(:select=>"id,name",:conditions=>["sections.personality_types like ? or sections.personality_types like ?","%#{trait1.to_i}%","%#{trait2.to_i}%"],:per_page=>10,:page=>params[:page])		
		# render :text => @sections.inspect and return false
 	end

	#Srinath Comments: When user requests for requestionare,remove all the previous answers and redirect to new questionare page 
 	def requestionare
 		@answers = Answer.where(:user_id=>current_user.id)
 		if @answers.present?
 			@answers.destroy_all
 		end
 		redirect_to questions_path,:notice => "New Questionare Started"
 	end

end
