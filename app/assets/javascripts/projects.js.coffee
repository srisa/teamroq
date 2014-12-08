$("document").ready ->
  $('#add-users-button').click (event)->
      if $('a.tagsinput-remove-link').length == 0
        event.stopPropagation()
        return false

  $("#new_project").validate
    rules:
      "project[name]": "required"
      "project[description]": "required"

    messages:
      "project[name]": "Please enter project name"
      "project[description]": "Please enter  project description"

  $(".standup-scroll-box").perfectScrollbar();
  $(".tasklist-scroll-box").perfectScrollbar();

  $(".expand-todolist").click (e) ->
    e.preventDefault()
    mainparent = $(this).parent().parent().parent()
    todolist = mainparent.find(".todolist-content")
    todolist.slideToggle()
  $("#overview-link").click (e) ->
    e.preventDefault()
    $(".active").removeClass("active");
    $("#overview-link").addClass("active");
    $(".main_content").hide()
    $(".overview_content").show()

  $(".add-followers-tagsinput").tagsInput
      autocomplete_url: "searchuser"
      removeWithBackspace: true
      placeholderColor : '#666666'
      autocomplete:
        source: (request, response) ->
          $.ajax
            url: "searchuser"
            dataType: "json"
            data:
              name: request.term

            success: (data) ->
              response $.map(data, (item) ->
                label: item.slug
                value: item.slug
              )

  todolist_id =''

  $(".add-watchers-tagsinput").tagsInput
      autocomplete_url: "addwatcher_task"
      removeWithBackspace: true
      placeholderColor : '#666666'
      autocomplete:
        source: (request, response) ->
          $.ajax
            url: "addwatcher_task"
            dataType: "json"

            data:
              name: request.term
              todo_list_id: $("#todo_todo_list_id").val()

            success: (data) ->
              response $.map(data, (item) ->
                label: item.slug
                value: item.slug
              )
