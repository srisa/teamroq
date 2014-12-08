// Place all the behaviors and hooks related to the matching controller here.
//All this logic will automatically be available in application.js.
//You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

	var url = $("#fileuploaditem").attr("data-post-url")
    $('#fileuploaditem').fileupload({
        dataType: 'json',
        url: url,
        add: function (e, data) {
        	$(".uploading-spinner").show()
          $("#file-progress-bar").show()
            // data.context = $('<p/>').text('Uploading...').appendTo(".uploaded-file-section");
            data.submit();
        },
        done: function (e, data) {
            var hiddenTag = "<input name='document_id' id='hdi-"+ data.result.id +"' type='hidden' value='"
             + data.result.id + "' />"
            var link = "<span class='hidden-doc-placeholder'><a href='/" + data.result.attachable_type.toLowerCase() 
              +"s/"+ data.result.attachable_id + "/documents/" + 
              data.result.id + "' data-item-id='"+data.result.id +"'>" + data.result.name + 
              "</a><a class ='document-item-remove-link' " + "data-item-id='" + data.result.id + "'><i class='fa fa-close'/></a></span>"
            $(".uploading-spinner").hide()
            $("#file-progress-bar").hide()            
            $(link).appendTo(".uploaded-file-section");
            $(hiddenTag).appendTo(".uploaded-file-section");
        },
        progressall: function (e, data) {
          var progress = parseInt(data.loaded / data.total * 100, 10);
          $('#file-progress-bar span').css(
              'width',
              progress + '%'
          );
        },
        fail: function(e,data){
            $('#file-progress-bar').hide();
            $(".uploading-spinner").hide()
            alert("There was some problem uploading the file. Please try later.");
        }
    });
  $(document).on('click',".document-item-remove-link", function(event){
    event.preventDefault();
    var removableId = $(this).attr("data-item-id");
    removableId = "#hdi-" + removableId;
    $(removableId).remove();
    $(this).closest('.hidden-doc-placeholder').remove();

  });
