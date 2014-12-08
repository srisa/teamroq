# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$("document").ready ->
  $(".search-user").autocomplete
    source: (request, response) ->
      $.ajax
        url: "searchuser"
        dataType: "json"
        data:
          name: request.term

        success: (data) ->
          response $.map(data, (item) ->
            label: item.name
            value: item.name
            id: item.id
          )
    minLength: 1
    select: ( event, ui ) -> 
      $(".search-user").val(ui.item.value)
      $(".userid").val(ui.item.id)

