
$("document").ready ->
  $(".calendar-field").datepicker({ minDate: 0, dateFormat: 'dd/mm/yy' })
  $("#notification-container").click ->
    $(".notification-bubble").hide()
    if ($(".notify-placeholder").length == 0)
      $("#notification-container").append("<div class='notify-placeholder' id = 'notification-placeholder' style='display:none;'></div>")

    $(".notify-placeholder").html("")
    if(!$('.notify-placeholder').is(':visible'))
      $.ajax
        url: "/notifications/show.json"
        dataType:"json"

        success: (data) ->
          count = 0
          $(".notify-placeholder").empty()
          $(".notify-placeholder").append("<div class='notification-header'>
            Notifications <a href='/notifications/showall'>(Show all)</a> </div>")
          while count <=data.length - 1
            activity = data[count]
            # trackable_name = jQuery.trim(activity.trackable_name).substring(0, 50).split(" ").slice(0, -1).join(" ") + "..."
            trackable_name = activity.trackable_name

            if activity.trackable_type == "Todo"
              action = ""
              if activity.action == "comment"
                action = "commented on"
              else if activity.action == "reopen"
                action = activity.action+"ed"
              else if activity.action == "user"
                action = "assigned you"
              else if activity.action == "date"
                action = "changed the date of"
              else
                action = activity.action+"d"
              $(".notify-placeholder").append("
                  <div class='notification-section'>
                      <div class='row wrapper-box'>
                        <div class='twelve columns'>
                          <p class='post-name float-left'>
                            <a href='/users/#{activity.user_id}' class='post-user-name'>#{activity.user.name}</a>
                            has #{action} the task 
                            <a href = '/todo_lists/#{activity.affected_id}/todos/#{activity.trackable_id}'>#{trackable_name} </a>
                            <small class='grey next-line pull_right'>
                              <i class='fa fa-clock-o'>
                                #{activity.updated_at_words} ago
                              </i>
                            </small>
                          </p>
                        </div>
                      </div>
                  </div>
                ")
            else
              if activity.trackable_type == "Answer" && activity.action == "create"
                $(".notify-placeholder").append("
                    <div class='notification-section'>
                        <div class='row wrapper-box'>
                          <div class='twelve columns'>
                            <p class='post-name float-left'>
                              <a href='/users/#{activity.user_id}' class='post-user-name'>#{activity.user.name}</a>
                              has answered the question
                              <a href = '#{activity.path}'>#{activity.affected_name} </a>
                              <small class='grey pull_right next-line'>
                                <i class='fa fa-clock-o'>
                                  #{activity.updated_at_words} ago
                                </i>
                              </small>
                            </p>
                          </div>
                        </div>
                    </div>
                  ")
              else if activity.trackable_type == "Discussion" && activity.action == "create"
                $(".notify-placeholder").append("
                    <div class='notification-section'>
                        <div class='row wrapper-box'>
                          <div class='twelve columns'>
                            <p class='post-name float-left'>
                              <a href='/users/#{activity.user_id}' class='post-user-name'>#{activity.user.name}</a>
                              has started a discussion in project
                              <a href = '#{activity.path}'>#{activity.affected_name} </a>
                              <small class='grey pull_right next-line'>
                                <i class='fa fa-clock-o'>
                                  #{activity.updated_at_words} ago
                                </i>
                              </small>
                            </p>
                          </div>
                        </div>
                    </div>
                  ")
              else
                action = activity.action+"ed"
                $(".notify-placeholder").append("
                  <div class='notification-section'>
                      <div class='row wrapper-box'>
                        <div class='twelve columns'>
                          <p class='post-name float-left'>
                            <a href='/users/#{activity.user_id}' class='post-user-name'>#{activity.user.name}</a>
                            has #{action} on #{activity.trackable_type.toLowerCase()}
                            <a href=#{activity.path}>#{trackable_name}</a>
                            <small class='grey pull_right next-line'>
                              <i class='fa fa-clock-o'>
                                #{activity.updated_at_words} ago
                              </i>
                            </small>
                          </p>
                        </div>
                      </div>
                  </div>
                ") 
            
            count++
    $(".notify-placeholder").show()
    $(".notification-bubble").html(0)

  $.ajax
    url: "/notifications/index.json"
    dataType:"json"

    success: (data) ->
      if data > 0
        $(".notification-bubble").show()
        $(".notification-bubble").html(data)

  $(".comment-input").keypress (e) ->
    if e.which is 13
      e.preventDefault()
      $(this).closest('form').submit()
      $(this).val("") 
 
  $(".add-topics-tagsinput").tagsInput
    autocomplete_url: "/search/autocomplete_tag"
    autocomplete:
      source: (request, response) ->
        $.ajax
          url: "/search/autocomplete_tag"
          dataType: "json"
          data:
            name: request.term

          success: (data) ->
            response $.map(data, (item) ->
              label: item.name
              value: item.name
            )
    interactive: true
    defaultText :'Add a topic and press enter'
    # placeholderColor: '#e5e5e5'

  $(".add-users-tagsinput").tagsInput
    autocomplete_url: "/search/autocomplete_user"
    removeWithBackspace: true
    placeholderColor : '#666666'
    autocomplete:
      source: (request, response) ->
        $.ajax
          url: "/search/autocomplete_user"
          dataType: "json"
          data:
            name: request.term

          success: (data) ->
            response $.map(data, (item) ->
              label: item.slug
              value: item.slug
            )
    defaultText :'Add multiple users. Type user name and select from dropdown'

# code to hide notifications when clicked outside
  $(document).mouseup (e) ->
    container = $("#notification-container")
    placeholder = $(".notify-placeholder")
    placeholder.hide()  if not container.is(e.target) and container.has(e.target).length is 0
    return false
     
  $(".comment-button").click (e)->
      e.preventDefault()
      $(this).parent().parent().next(".commentlist").toggle()

  #form validation for avoiding adding empty comments
  $(".new_comment").each ->
    form = $(this)
    form.validate
        rules:
          "comment[content]": "required"
        messages:
          "comment[content]": "Please enter something in comments before submitting"
        errorPlacement: 
          (error, element) ->
            parent = element.parent()
            parent.append(error)

  $.widget "custom.catcomplete", $.ui.autocomplete,
      _renderMenu: (ul, items) ->
        that = this
        currentCategory = ""
        $.each items, (index, item) ->
          unless item.context is currentCategory
            ul.append "<li class='ui-autocomplete-category'>" + item.context + "</li>"
            currentCategory = item.context
          that._renderItemData ul, item

  $(".search-query").catcomplete
    source: (request, response) ->
      $.ajax
        url: "/search/autocomplete"
        dataType: "json"
        data:
          name: request.term

        success: (data) ->
          response $.map(data, (item) ->
            label: item.name
            value: item.name
            path: item.path
            context: item.context
          )
    minLength: 3
    select: ( event, ui ) -> 
      window.location.href = ui.item.path;

  $(".search-user-todo").autocomplete
    source: (request, response) ->
      $.ajax
        url: "searchuser"
        dataType: "json"
        data:
          name: request.term
          todo_list_id: $("#todo_todo_list_id").val()

        success: (data) ->
          response $.map(data, (item) ->
            label: item.name
            value: item.name
            id: item.id
          )
    minLength: 1
    select: ( event, ui ) -> 
      $(".search-user-todo").val(ui.item.value)
      $(".userid").val(ui.item.id)




