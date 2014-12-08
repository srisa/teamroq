class DocumentProcessingJob
  @queue = :documents
  @logger = Logger.new 'log/resque.log'

  def self.perform(activity_id, document_id)
    @document = Document.find(document_id)
    @attachable = @document.attachable
    if @attachable.is_a? Project
      @attachable.users.each do |user|
        user.add_to_feed activity_id
        user.save
      end
    end
  end

end