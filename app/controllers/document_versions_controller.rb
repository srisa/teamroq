class DocumentVersionsController < ApplicationController
  before_filter :load_document

  #POST /projects/1/documents/1/document_versions
  #POST /groups/1/documents/1/document_versions
  def create
    @document_version = @document.document_versions.build(document_version_params)
    respond_to do |format|
      if @document.save
        track_document_activity @document, :update
        format.html {redirect_to :back}
      else
        format.html {redirect_to :back}
      end
    end
  end

  # GET /projects/1/documents/1/document_versions/1/download
  # GET /groups/1/documents/1/document_versions/1/download
  def download
    @document_version = @document.document_versions.find(params[:document_version_id])
    redirect_to @document_version.file.url
  end

  private
    def document_version_params
      params.require(:document_version).permit(:file,:release_note)
    end

    def load_document
      @document = Document.find(params[:document_id])
    end
end
