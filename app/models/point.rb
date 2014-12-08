class Point < ActiveRecord::Base
  	# attr_accessible :type_id, :user_id, :value

	belongs_to :type  
	belongs_to :user  
end
