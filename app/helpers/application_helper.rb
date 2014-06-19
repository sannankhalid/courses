module ApplicationHelper
	def page_entries_info(collection, options = {})
	  entry_name = options[:entry_name] || (collection.empty?? 'item' :
	      collection.first.class.name.split('::').last.titleize)
	  if collection && collection.total_pages < 2
	    case collection.size
	    when 0; ''#"No #{entry_name.pluralize} found"
	    when 1; "Displaying 1 #{entry_name.singularize}"
	    else; "Displaying #{collection.size} #{entry_name.pluralize}"
	    end
	  else
	    %{Displaying %d - %d of %d #{entry_name.pluralize}} % [
	      collection.offset + 1,
	      collection.offset + collection.length,
	      collection.total_entries
	    ]
	  end
	end

	#Srinath Comments: Creating Select field for search by using the variable @columns from coures controller
	def filter_helper(params)
		keyword = []
		if params[:f]
	      fields = params[:option].split('@')
	      if fields[1]=="list"
	         keyword = [" #{fields[0]} = ?", params[:f][fields[0]]]
	      elsif fields[1]=="integer"
	      	 if !params[:f][fields[0]].blank?
	         	keyword = [" #{fields[0]} = ?", params[:f][fields[0]].to_i]
	         end
	      elsif fields[1]=="date"
	      	if (params[:f].has_key?(fields[0]) and params[:f][fields[0]].has_key?('from') and !params[:f][fields[0]][:from].blank?)
		        @from = params[:f][fields[0]][:from] if (params[:f].has_key?(fields[0]) and params[:f][fields[0]].has_key?('from'))
		        @to = params[:f][fields[0]][:to] if (params[:f].has_key?(fields[0]) and params[:f][fields[0]].has_key?('to')and !params[:f][fields[0]][:to].blank?)
		        @to ||= @from
		        keyword = [" DATE(#{fields[0]}) >= ? AND DATE(#{fields[0]}) <= ? ", @from.to_date,@to.to_date]
	      	end
	      else
	        keyword = [" #{fields[0]} LIKE ?", "%#{params[:f][fields[0]]}%"]
	      end
	    end
	    if params[:alpha_search] == 'Yes'
	        keyword = [" #{params[:char_field]} LIKE ?", "#{params[:keyword]}%"]
	    end
	    return keyword
	end	
end
