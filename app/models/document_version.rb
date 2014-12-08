class DocumentVersion < ActiveRecord::Base
  belongs_to :document
  #attr_accessible :release_note,:file
  has_attached_file :file, :preserve_files => true

  validates_presence_of :file
  # TODO
  # validates_attachment :file, content_type: { content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif","application/pdf","application/zip"] }
  do_not_validate_attachment_file_type :file
end
