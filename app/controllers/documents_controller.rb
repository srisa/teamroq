class DocumentsController < ApplicationController
 before_filter :load_commentable

  # GET /attachable/1/documents
  # GET /attachable/1/documents.json
  def index
    @documents = @attachable.documents
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @documents }
    end
  end

  # GET /attachable/1/documents/1
  # GET /attachable/1/documents/1.json
  def show
    @document = @attachable.documents.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @document }
    end
  end

  # GET /attachable/1/documents/new
  # GET /attachable/1/documents/new.json
  def new
    @document = @attachable.documents.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @document }
    end
  end

  # POST /attachable/1/documents
  # POST /attachable/1/documents.json
  def create
    @document = @attachable.documents.new(document_params)
    @document.user = current_user
    respond_to do |format|
      if @document.save
        track_document_activity_create @document
        format.html { redirect_to [@attachable,:documents], notice: 'Document was successfully created.' }
        format.json { render json: @document, status: :created, location: @document }
      else
        format.html { render action: "new" }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /attachable/1/documents/edit
  # GET /attachable/1/documents/edit.json
  def edit
    @document = @attachable.documents.find(params[:id])
    respond_to do |format|
      format.html # edit.html.erb
      format.json { render json: @document }
    end
  end

  # POST /attachable/1/documents
  # POST /attachable/1/documents.json
  def update
    @document = @attachable.documents.find(params[:id])
    @document.user = current_user
    respond_to do |format|
      @document.document_versions.build(update_document_version_params)
      if @document.save
        track_document_activity @document, :update
        format.html { redirect_to [@attachable,@document], notice: 'Document was successfully created.' }
        format.json { render json: @document, status: :created, location: @document }
      else
        format.html { render action: "edit" }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /attachable/1/documents/1
  # DELETE /attachable/1/documents/1.json
  def destroy
    @document = @attachable.documents.find(params[:id])
    @document.destroy

    respond_to do |format|
      format.html { redirect_to [@attachable, :documents] }
      format.json { head :no_content }
    end
  end

  # GET /attachable/1/documents/1/download
  def download
    @document = @attachable.documents.find(params[:id])
    redirect_to @document.document_versions.first.file.url
  end

  # POST /projects/1/attachment.json
  def attachment
    @document_version = DocumentVersion.new(document_version_params)
    @document = @attachable.documents.build(name: @document_version.file_file_name)
    @document.user = current_user
    respond_to do |format|
      if @document.save
        @document_version.document = @document      
          if @document_version.save
            format.json { render json: @document, status: :created}
          end
      end
      format.json { render json: @document.errors, status: :unprocessable_entity }
    end
  end

private

  def document_params
    params.require(:document).permit(:name, document_versions_attributes: [:file, :release_note])
  end

  def document_version_params
    params.require(:document_version).permit(:file,:release_note)
  end

  def update_document_version_params
    params.require(:document_versions).permit(:file,:release_note)
  end

  def load_commentable
    klass = [Project,Group,Post].detect { |c| params["#{c.name.underscore}_id"]}
    @attachable = klass.find(params["#{klass.name.underscore}_id"])
  end


end
