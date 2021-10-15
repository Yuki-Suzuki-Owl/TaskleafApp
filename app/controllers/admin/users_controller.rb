class Admin::UsersController < ApplicationController
  before_action :logged_in_user
  before_action :admin_only,only:[:index,:new,:create,:destroy]
  before_action :collect_user,only:[:show,:edit,:update]
  def index
    @users = User.page(params[:page])
    @groups = Group.all
    @group = Group.new
  end

  def show
    # No need.
    # @user = User.find(params[:id])
  end

  def new
    @user = User.new()
  end

  def create
    # group = Group.find_by(params[:group_id])
    # @user = group.users.new(user_params)
      # or
    # @user = User.buld_group(user_params)
    # @user.save
    @user = User.new(admin_user_params)
    if @user.save
      flash[:success] = "#{@user.name} created!"
      redirect_to admin_users_path
    else
      render "new"
    end
  end

  def edit
    # @user = User.find(params[:id])
  end

  def update
    # @user = User.find(params[:id])
    if current_user.admin?

      group = @user.group
      if @user.update(admin_user_params)
        if @user.group != group
          group.tasks.each do |task|
            if @user.tasks.include?(task)
              task.destroy
            end
          end
          flash[:info] = "Published group_tasks are now private."
        end
        flash[:success] = "#{@user.name} updated!"
        redirect_to admin_user_path
      else
        render "edit"
      end

    else
      # !current_user.admin?
      if @user.update(user_params)
        flash[:success] = "password changed."
        redirect_to [:admin,@user]
      else
        render "edit"
      end

    end
  end

  def destroy
    @user = User.find_by(id:params[:id])
    if !@user.admin? && @user.destroy
      flash[:success] = "#{@user.name} destroyed."
      redirect_to admin_users_path
    else
      flash[:danger] = "cannot delete..."
      @group = Group.new
      render "index"
    end
  end

  private
    def admin_user_params
      params.require(:user).permit(:name,:email,:password,:password_confirmation,:group_id)
    end

    def user_params
      params.require(:user).permit(:password,:password_confirmation)
    end


    def admin_only
      redirect_to [:admin,current_user] unless current_user.admin?
    end

    def collect_user
      @user = User.find_by(id:params[:id])
      unless current_user.admin? || (current_user == @user)
        redirect_to [:admin,current_user]
      end
    end
end
