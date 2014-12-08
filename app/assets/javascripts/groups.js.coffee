# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

#form validation for add post
$("document").ready ->
  $(".new_post").validate
      ignore: []
      rules:
        "post[title]": "required"
        "post[content]": "required"
      messages:
        "post[title]": "Please specify the title for this post"
        "post[content]": "Please describe this post"

  $("#new_group").validate
    rules:
      "group[name]": "required"
      "group[description]": "required"

    messages:
      "group[name]": "Please enter group name"
      "group[description]": "Please enter  group description"

