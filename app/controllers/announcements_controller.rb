class AnnouncementsController < ApplicationController
  before_filter :get_user_and_load_announcable

  # GET /announcements
  # GET /announcements.json
  def index
    @announcements = @announcable.announcements

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @announcements }
    end
  end

  # GET /announcements/1
  # GET /announcements/1.json
  def show
    @announcement = @announcable.announcements.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @announcement }
    end
  end

  # GET /announcements/new
  # GET /announcements/new.json
  def new
    @announcement = @announcable.announcements.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @announcement }
    end
  end

  # GET /announcements/1/edit
  def edit
    @announcement = @announcable.announcements.find(params[:id])
  end

  # POST /announcements
  # POST /announcements.json
  def create
    @announcement = @announcable.announcements.build(announcement_params)

    respond_to do |format|
      if @announcement.save
        format.html { redirect_to group_announcements_path(@announcable), notice: 'Announcement was successfully created.' }
        format.json { render json: @announcement, status: :created, location: @announcement }
      else
        format.html { render action: "new" }
        format.json { render json: @announcement.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /announcements/1
  # PUT /announcements/1.json
  def update
    @announcement = @announcable.announcements.find(params[:id])

    respond_to do |format|
      if @announcement.update_attributes(announcement_params)
        format.html { redirect_to [@announcable,@announcement], notice: 'Announcement was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @announcement.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /announcements/1
  # DELETE /announcements/1.json
  def destroy
    @announcement = @announcable.announcements.find(params[:id])
    @announcement.destroy

    respond_to do |format|
      format.html { redirect_to :back }
      format.json { head :no_content }
    end
  end


  private
    def announcement_params
      params.require(:announcement).permit(:content)
    end

    def get_user_and_load_announcable
      @user = current_user
      klass = [Group].detect { |c| params["#{c.name.underscore}_id"]}
      @group = @announcable = klass.find(params["#{klass.name.underscore}_id"])
    end
end
