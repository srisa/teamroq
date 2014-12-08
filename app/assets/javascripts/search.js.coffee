$(document).on "keyup", ".search-queryShowinginLi", ->
  $("#search-results").html("")

  $.get "/search/autocomplete", 
    name: $(".search-query").val(),
    ((data) ->
      count = 0

      while count <= data.length - 1
        user = data[count]
        $("#search-results").append("<li> <a href = #{user.path}> #{user.name} </a> </li>")
        count++
      ), "json"



        


