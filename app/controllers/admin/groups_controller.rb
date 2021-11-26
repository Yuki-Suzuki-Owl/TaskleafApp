class Admin::GroupsController < ApplicationController
  before_action :logged_in_user,:admin_only
  def index
    # No need index index and new => admin_user_show
    @groups = Group.all
    @group = Group.new
  end

  def show
    @group = Group.find_by(id:params[:id])
    # @group_users = @group.users.all
  end

  def create
    @group = Group.new(group_params)
    if @group.save
      flash[:success] = "#{@group.name} created!"
      redirect_to admin_users_path
    else
      @groups = Group.all
      @users = User.page(params[:page])
      # @users = User.all
      render "admin/users/index"
    end
  end

  def update
    @group = Group.find_by(id:params[:id])
    if @group.update(group_params)
      flash[:success] = "#{@group.name} updated!"
      redirect_to admin_group_path(@group)
    else
      @group.reload.name
      render "show"
    end
  end

  def destroy
    @group = Group.find_by(id:params[:id])
    if @group.users.empty? && @group.delete
      flash[:success] = "#{@group.name} deleted."
      redirect_to admin_users_path
    else
      @groups = Group.all
      @users = User.page(params[:page])
      flash[:danger] = "#{@group.name} is not empty!"
      render "admin/users/index"
    end
  end

  private
    def admin_only
      redirect_to admin_user_path(current_user) unless current_user.admin?
    end
    def group_params
      params.require(:group).permit(:name)
    end
end
