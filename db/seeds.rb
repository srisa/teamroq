
#################################################################
#
#
# Test data 
#---------------------------------------------------------------
#
#   D Create 100 users. Each user follows 30 other users.
#  	D 50 users ask 20 questions each
#   D Total 25 topics are created(No idea)
#   D 15 projects are created.
#   D 10 teams are created.
#   D Each project has minimum of 10-30 team members.
#   D Each team has 5-20 team members.
#
#
#################################################################
require 'faker'


180.times { |i| 
	name = Faker::Name.name
	email = "user-#{i}@a.com"
password = "foobar123"
	User.create!(:name => name, :email => email, :password => password, :password_confirmation => password) }


50.times { |i|
	user = User.find(i+2)
	20.times {|j|
	title = Faker::Lorem.sentences(1).to_s
	content = Faker::Lorem.paragraphs(1).to_s
	topics_list = Faker::Lorem.words(2).join(",").to_s
	question = user.questions.build(:title => title, :content => content,:topic_list=>topics_list)
	question.save!
	}
  
}

15.times{ |i|
	project = Project.create!(:name=>Faker::Lorem.word.to_s,:description => Faker::Lorem.paragraph(1).to_s)
	i+10.times{|j|
		user = User.find((i)*10+j+1)
		project.project_roles.build(:user_id => user.id)
	}
	project.save!
}

10.times{|i|
	group = Group.create!(:name=>Faker::Lorem.word.to_s,:description => Faker::Lorem.paragraph(1).to_s)
	i+10.times{|j|
		user = User.find((i)*10+j+1)
		group.group_roles.build(:user_id => user.id)
	}
	group.save!
	
}

50.times{|i|
	question = Question.find(i+1)
	user = User.find(i+1)
	3.times{|j|
		content = Faker::Lorem.paragraph(1).to_s
		answer = question.answers.build(:content => content)
		answer.user = user
		answer.save!
	}

}
require "#{Rails.root}/db/gioco/db.rb"