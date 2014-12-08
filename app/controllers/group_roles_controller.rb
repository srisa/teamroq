class GroupRolesController < ApplicationController
  before_filter :get_user_and_group, :only => [:new,:create]
  before_filter :get_user_and_model, :except => [:new,:create]
  
  # POST /group_roles
  # POST /group_roles.json
  def create
    @group_role = @group.group_roles.build(params[:group_role])
    @user = User.find_by_email(params[:user][:email])
    unless @user
      errors.add(:base, "Invalid email address")
      redirect_to @group_role
    end
    @group_role.user = @user
    respond_to do |format|
      if @group_role.save
        format.html { redirect_to @group, notice: 'Group role was successfully created.' }
        format.json { render json: @group_role, status: :created, location: @group_role }
      else
        format.html { render action: "new" }
        format.json { render json: @group_role.errors, status: :unprocessable_entity }
      end
    end
  end


  # DELETE /group_roles/1
  # DELETE /group_roles/1.json
  def destroy
    @group_role = @role_model.group_roles.find(params[:id])
    @group_role.destroy

    respond_to do |format|
      format.html { redirect_to @role_model }
      format.json { head :no_content }
    end
  end

  
  private

    def role_params
      params.require(:group_roles).permit(:user_id,:group_id)
    end

    def get_user_and_model
      klass = [User,Group].detect { |c| params["#{c.name.underscore}_id"]}
      @role_model = klass.find(params["#{klass.name.underscore}_id"])
    end

    def get_user_and_group
      @group = current_user.groups.find(params[:group_id])  
    end
end
