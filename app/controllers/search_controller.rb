class SearchController < ApplicationController

  # GET /search/autocomplete.json
  def autocomplete
  
    results = User.search(params["name"])
    questions = Question.search(params["name"])
    projects = Project.search(params["name"])
    groups = Group.search(params["name"])
    tags = ActsAsTaggableOn::Tag.where("name ilike ?", '%'+params["name"]+'%')

    questions.each do |item|
      results.push(item)
    end

    projects.each do |item|
      results.push(item)
    end

    groups.each do |item|
      results.push(item)
    end

    tags.each do |item|
      results.push(item)
    end
    
    render :json => results
  end

  # GET /search/autocomplete_user.json
  def autocomplete_user
    users = User.whose_name_starts_with(params[:name])
    render :json => users.to_json(:only => [ :id, :slug ])
  end

  # GET /search/autocomplete_tag.json
  def autocomplete_tag
    name = "%"+params[:name]+"%"
    tags = ActsAsTaggableOn::Tag.where("name ilike ? ",name)
    render :json => tags
  end

end

# Monkey patching
class ActsAsTaggableOn::Tag
  def attributes
   super.merge({"context" => "topic", "path" => "/topics/"+self.name})
  end

  def path
    "/topics/"+name
  end

  def context
    "topic"
  end

end