pageNumber = 2
urlToCall = '/activities?page='
processing = false
$("document").ready ->
  if $('.activity-list').length
    $(window).scroll ->
      if $(window).scrollTop() > $(document).height() - $(window).height() - 50
        if !processing
          console.log urlToCall+pageNumber
          processing = true
          $.ajax
            url: urlToCall+pageNumber
            dataType: 'script'
            success: (data) ->
              if $('.activity-results').length
                pageNumber = pageNumber+1
                processing = false
