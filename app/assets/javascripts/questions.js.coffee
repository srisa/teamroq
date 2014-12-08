interestingPage = 2
newestPage = 2
unansweredPage = 2
sortByVotesPage = 2
interestingTrue = true
newestTrue = false
unansweredTrue = false
sortByVotesTrue = false
interesting_processing = false
newest_processing = false
unanswered_processing = false
sortByVotes_processing = false

$("document").ready ->
  config = toolbar: [["Source", "-", "Bold", "Italic", "Underline", "-", "NumberedList", "BulletedList", "-", "Blockquote", "-", 'JustifyLeft', 'JustifyCenter', 'JustifyRight', 'JustifyBlock', "-", 'Undo', 'Redo']]
  $(".expanded_comment_box").hide()
  $(".take_to_answer_btn").click ->
    ans_text_area = $(".postanswerbox")
    ans_text_area.focus()

  $(".answer_number_div").click ->
    $(window).scrollTop $(".answernumber").offset().top

  $(".related_question_upvote").attr "title", "Number of upvotes received"
  $(".votenumber").attr "title", "Number of upvotes received"
  $(".reputation").attr "title", "Reputation score of this user"
  $(".taginfo").attr "title", "Tagged to this topic"
  $(".icon-up-dir").attr "title", "This is useful"
  $(".icon-down-dir").attr "title", "This is not useful"
  $(".icon-export").attr "title", "Click to share this"

  #form validation for add question
  $(".new_question").validate
      ignore: []
      rules:
        "question[title]": "required"
        "question[content]": "required"
        "question[topic_list]": "required"
      messages:
        "question[title]": "Please specify the title for this question"
        "question[content]": "Please describe this question"
        "question[topic_list]": "Please assign this question to some topics"


  $("#submit-answer-button").click (e) ->
    
    CKEDITOR.instances.answer_content.updateElement()
    
    data = CKEDITOR.instances.answer_content.getData()
    if data.trim() == ''
      e.preventDefault()
      alert("You cannot submit an empty answer")
      return false
    else
      $(".new_answer").submit()

  $(".search-topic-query").autocomplete
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
              path: item.path
              context: item.context
            )
      minLength: 1
      select: ( event, ui ) -> 
        window.location.href = ui.item.path;


  #disabling prevent event behavior of disabled voting link if current user is same as model owner
  $(".disabled-vote").click (event) ->
    event.preventDefault()
    event.stopPropagation()
    return false

