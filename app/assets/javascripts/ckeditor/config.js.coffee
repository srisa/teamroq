CKEDITOR.editorConfig = (config) ->
  config.language = 'en'
  config.toolbar_Pure = [
    { name: 'basicstyles', items: [ 'Bold','Italic','Underline','Strike' ] },
    { name: 'paragraph',   items: [ 'NumberedList','BulletedList'] },
    { name: 'links',       items: [ 'Link','Unlink'] },
    { name: 'styles',      items: [ 'Format'] }
  ]
  config.toolbar = 'Pure'
  true