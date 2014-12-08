$(document).ready ->
  $(".follow-btn-user").on "ajax:success", (e) ->
    #alert('clicked')
    $this = $(this)
    superParent = $this.parent().parent()
    superParent.html('<div class="pretty medium secondary btn following-btn"><a href="#">Following</a></div>')

