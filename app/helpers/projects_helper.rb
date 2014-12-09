module ProjectsHelper
	def add_users_to_project user_list,project
    unless user_list.nil? || user_list.empty?
	    user_arr = user_list.split(',')
	    user_arr.each do |u|
		    user = User.where(slug: u.strip).first
		    unless user.nil?
			    existing_project = user.projects.where(:id => project.id)
		      if existing_project.empty?
		        user.projects.push(project)
		      end
			  end
			end
	  end
	end

	
	def modify_hash_to_use_key_name data_object
		data= Hash.new
    	data_object.each do |key,value|
     		data[key.name]=value
    	end
    return data
	end

	def sum_values_in_hash original_hash
		sum = 0
		original_hash.each do |k,v|
			sum = sum + original_hash[k]
			original_hash[k] = sum
		end
		original_hash
	end

	def subtract_hash hash1,hash2
		hash1.each do |k,v|
			value = hash2[k]
			unless value.nil?
				hash1[k] = hash1[k]-value
			end
		end
		hash1
	end

end
