require 'faker'
require 'rack/test'

FactoryGirl.define do

  factory :user do |f|
    f.email {Faker::Internet.email}
    f.password "foobar123"
    f.password_confirmation "foobar123"
    f.profile_picture Rack::Test::UploadedFile.new(Rails.root + 'spec/factories/add.png', 'image/png')
    f.name {Faker::Name.name}
  end

  factory :question do |f|
    f.title "randomquestion"
    f.content Faker::Lorem.paragraphs(1).to_s
    f.topic_list Faker::Lorem.words(2).join(',')
  end

  factory :discussion do |f|
    f.title Faker::Lorem.sentences(1).to_s
    f.content Faker::Lorem.paragraphs(1).to_s
  end

  factory :post do |f|
    f.title Faker::Lorem.sentences(1).to_s
    f.content Faker::Lorem.paragraphs(1).to_s
    association :user, factory: :user
    association :postable, factory: :group
  end

  factory :answer do |f|
    f.content Faker::Lorem.paragraphs(1).to_s
    association :question, factory: :question
  end

  factory :comment do |f|
    f.content {Faker::Lorem.paragraphs(1).to_s}
    association :user, factory: :user
    association :commentable, factory: :question
  end


  factory :project do |f|
    f.name "RandomProject"
    f.description Faker::Lorem.paragraphs(1).to_s
  end


  factory :group do |f|
    f.name "Group"
  end

  factory :group_role do |f|
  end

  factory :announcement do |f|
    f.content Faker::Lorem.paragraphs(1).to_s
    association :announcable, factory: :group
  end

  factory :type do |f|
    f.name "ProActive"
  end

  factory :document do |f|
    f.name "Test"
    association :attachable, factory: :project
  end

  factory :document_version do |f|
    association :document, factory: :document
    f.file Rack::Test::UploadedFile.new(Rails.root + 'spec/factories/add.png', 'image/png')
    f.release_note Faker::Lorem.sentences(1).to_s
  end


  factory :todo_list do |f|
    f.name "Todolistdefault"
    association :project, factory: :project
  end

  factory :todo do |f|
    f.name "doit"
    f.details "more details"
    f.target_date 2.days.from_now
    association :todo_list, factory: :todo_list
    association :user, factory: :user
  end

  factory :comment_for_todo, class: :comment do |f|
    f.content {Faker::Lorem.paragraphs(1).to_s}
    association :user, factory: :user
    association :commentable, factory: :todo
  end

  factory :activity do |f|
    association :trackable, factory: :question
    association :user, factory: :user
    f.path "/questions"
    f.action "create"
  end

  factory :activity_for_todo, class: :activity do |f|
    association :trackable, factory: :todo
    association :user, factory: :user
    f.path "/questions"
    f.action "comment"
  end

end

