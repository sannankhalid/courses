require 'rubygems'
require 'csv'    

namespace :load do
  desc "Load Courses"
  task :master => :environment do
    
    Course.destroy_all
    Section.destroy_all
    csv_text = File.read("#{Rails.root}/lib/data/master_courses.csv")
    csv = CSV.parse(csv_text, :headers => true)
    csv.each do |row|
    	row = row.to_hash
	  	row.delete("id")
	  	row.delete("updated_at")
	  	row.delete("created_at")
	  	@section = Section.find_by_name(row["section"])
	  	unless @section.present?
	  		@section = Section.create(:name=>row["section"],:status=>true)
	  	end
      @course = Course.new(row)
      @course.department = @section 
      @course.save
    end
         
  end


   desc "Load admin"
   task :create_admin => :environment do
   User.create(:email=>"anurag.chaudhari@hotmail.com", :password=>"anurag12345", :password_confirmation=>"anurag12345",:user_type=>"admin")
  end

  desc "Load Courses"
  task :dept_mapper => :environment do
    depts = {"Social Sciences"=>["4", "5"], "Counseling and School Psychology"=>["1", "2"], "Civil and Environmental Engineering"=>["2", "3"], "Urban Studies and Planning"=>["4", "5"], "Science, Technology, and Society"=>["1", "2", "3"], "Electrical Engineering and Computer Science"=>["1", "2", "3"], "Aeronautics and Astronautics"=>["2"], "Music and Theater Arts"=>["3"], "Earth, Atmospheric, and Planetary Sciences"=>["1", "2"], "Materials Science and Engineering"=>["1", "2"], "Literature"=>["3"], "Writing and Humanistic Studies"=>["3"], "Foreign Languages and Literatures"=>["3", "4"], "Physics"=>["2"], "Comparative Media Studies"=>["3", "4"], "Biology"=>["1", "2"], "Brain and Cognitive Sciences"=>["2"], "Political Science"=>["1", "4", "5"], "Linguistics and Philosophy"=>["3"], "Special Programs"=>["4"], "Mechanical Engineering"=>["1", "2"], "Chemical Engineering"=>["1", "2"], "Sustainable Development"=>["1", "2"], "Engineering"=>["1", "2"], "Biological Engineering"=>["1", "2"], "Mathematics"=>["2"], "Chemistry"=>["2"], "Sloan School of Management"=>["5"], "History"=>["4", "6"], "Media Arts and Sciences"=>["3", "4"], "Engineering and Technology"=>["1", "2"], "International Health"=>["1", "2"], "Nuclear Science and Engineering"=>["2"], "PHYS"=>["2"], "Architecture"=>["3"], "Watermanagement"=>["1", "2"], "Economics"=>["1", "5", "6"], "Anthropology"=>["3"], "Health Sciences and Technology"=>["1", "2"], "Arabic and Middle East Studies"=>["3", "4"], "Classics"=>["3"], "MCDB"=>["2"], "Biostatistics"=>["2", "6"], "Center for Social Concerns"=>["4"], "Engineering Systems Division"=>["1", "2"], "Resource Home"=>["4"], "Department of Health, Behavior and Society"=>["1", "4"], "MUSI"=>["3"], "Department of Population, Family and Reproductive Health"=>["1"], "Bloomberg School of Public Health"=>["1", "2"], "Master of Public Health Program"=>["1"], "Athletics, Physical Education and Recreation"=>["1"], "ENGL"=>["3"], "Department of International Health"=>["1", "2"], "Microelectronics"=>["1", "2"], "Department of Biostatistics"=>["2", "6"], "Office of the Dean"=>["1", "4"], "Population, Family, and Reproductive Health"=>["2"], "Transportation and Planning"=>["1", "6"], "Latino Studies"=>["3", "4", "6"], "Department of Health Policy and Management"=>["1", "4"], "Theology"=>["4"], "Inicio"=>["3"], "CHEM"=>["2"], "Philosophy"=>["2"], "Department of Population and Family Health Sciences"=>["1"], "Offshore Engineering"=>["1", "2"], "Population and Family Health Sciences"=>["1"], "First Year of Studies"=>["1"], "Berman Institute for Bioethics and The Johns Hopkins Center for Clinical Global Health Education"=>["2"], "Political Philosophy."=>["2", "5"], "Nanoscience"=>["2"], "BENG"=>["1"], "Special Education"=>["1"], "Department of Environmental Health Sciences"=>["2"], "Department of Mental Health"=>["2"], "CLCV"=>["3"], "PSYC"=>["2"], "HSAR"=>["3"], "Molecular Microbiology and Immunology"=>["2"], "Computer Applications"=>["1", "2"], "Department of Population, Family, and Reproductive Health"=>["1", "2"], "Environmental Health Sciences"=>["2"], "Department of Population, Family &amp; Reproductive Health Science"=>["1", "2"], "ECON"=>["5", "6"], "Extradepartmental"=>["2"], "Psychology"=>["2"], "Public Policy"=>["4", "5"], "Communication Studies"=>["4"], "RLST"=>["6"], "Romance Languages and Literatures"=>["3"], "Performing Arts"=>["3", "4"], "Africana Studies"=>["3"], "Nursing and Health Sciences"=>["1", "2"], "American Studies"=>["6"], "Media and Knowledge Engineering"=>["1", "3"], "Health Policy and Management"=>["1"], "Biomedical Engineering"=>["1", "2"], "EEB"=>["2"], "Department of Health, Behavior, and Society"=>["2", "4"], "Department of Biostatistics and The Johns Hopkins Center for Clinical Global Health Education"=>["1", "2"], "Gender Studies"=>["2", "3"], "Department of Population. Family, and Reproductive Health"=>["1"], "Peace Studies"=>["4"], "Mental Health"=>["2"], "Department of Epidemiology"=>["2"], "Center For Public Health Preparedness"=>["1"], "Computer Science"=>["1", "2"], "ASTR"=>["2"], ""=>[], "Sociology"=>["4"], "University Resources"=>["1", "5"], "ITAL"=>["3"], "Johns Hopkins Center For Public Health Preparedness"=>["1"], "Information Skills"=>["1", "2"], "English"=>["3"], "Critical and Creative Thinking"=>["2", "3"], "Engineering and Policy Analysis"=>["1", "2"], "HIST"=>["3"], "Graduate Training Programs in Clinical Investigation"=>["2"], "Environmental, Earth, and Ocean Sciences"=>["1", "2"], "Office of Communications and Public Affairs"=>["4"]}

    depts.each do |k,v|
      @section = Section.find_by_name(k)
      if v.present? and @section.present? 
        @section.personality_types = v 
        @section.save
      end
    end
    vals={}
     @sections=Section.all
     @sections.each { |e|
        vals[e.name] = e.personality_types
       }
       puts vals
    # # csv_text = File.read("#{Rails.root}/lib/data/departments.csv")
    # # csv = CSV.parse(csv_text, :headers => true)
    # # csv.each do |row|
    # #   row = row.to_hash      
    # #   # puts row["personality_types"].gsub( /"/, '').gsub("[","").gsub("]","").gsub(" ","").to_class
    # #   # @section.personality_types = row["personality_types"].gsub("[","").gsub("]","").gsub(" ","").split(",").map(&:to_i) 
    # #   # @section.save
    # # end
         
  end



end