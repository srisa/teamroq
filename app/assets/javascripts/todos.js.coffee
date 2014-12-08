$("document").ready ->

  $('#add-followers-button').click (event)->
    if $('a.tagsinput-remove-link').length == 0
      event.stopPropagation()
      return false
      
  $('.followers-number').click (event)->
    $('.show-followers').toggle()
    event.stopPropagation()
    event.preventDefault()

  $(".change-user-link").click ->
    $(".change-user-form").toggle()

  $(".closeform").click ->
    $(".change-user-form").toggle()
    return false

  $(".change-date-link").click ->
    $(".change-date-form").toggle()

  $(".closedateform").click ->
    $(".change-date-form").toggle()
    return false

$("document").ready ->
  $(".todo-calendar-field").each ->
    $("#" + $(this).attr("id")).datepicker({ dateFormat: 'dd/mm/yy' })

  #form validation for add todo_list
  $("#new_todo_list").validate
      rules:
        "todo_list[name]":
          required: true
          maxlength: 50
      messages:
        "todo_list[name]":
          required: "Please specify the title for this todo list"
          maxlength: "Please restrict the title to 50 characters"
        
  #form validation for add todo

  $(".new_todo").each ->
    form = $(this)
    form.validate
      rules:
        "todo[name]":
          required: true
          maxlength: 50
        "todo[details]": "required"
        "todo[assignee]": "required"
        "todo[target_date]":
          required: true
          date: true

      messages:
        "todo[name]":
          required: "Please specify the title for this todo"
          maxlength: "Please restrict the title to 50 characters"
        "todo[details]": "Please describe this todo"
        "todo[assignee]": "Please assign this todo to someone"
        "todo[target_date]":
          required: "Please specify the target date"
          date: "The target date must be in correct format"


  


