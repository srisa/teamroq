class Type < ActiveRecord::Base
  	# attr_accessible :name, :id
  	
	validates :name, :presence => true
	validates :name, :uniqueness => true
	
	has_many :badges  
	has_many :points  
end
