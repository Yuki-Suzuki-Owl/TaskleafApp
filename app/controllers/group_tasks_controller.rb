class GroupTasksController < ApplicationController
  before_action :logged_in_user

  def index
    @title = "Group Tasks"
    @tasks = current_user.group.tasks
    render "/tasks/index"
  end

  def show
    @task = current_user.group.tasks.find(params[:id])
    render "tasks/show"
  end

  # def create
  #   user = User.find(params[:user_id])
  #   if (user == current_user) && (task = user.tasks.find(params[:task_id]))
  #     if user.group.tasks << task
  #       flash[:success] = "Publish task: '#{task.title}' to group(#{user.group.name}!) "
  #       redirect_to group_tasks_path
  #     else
  #       flash[:danger] = "something is wrong! this task already published?"
  #       render "tasks/index"
  #     end
  #   else
  #     flash[:danger] = "something is wrong! not your task"
  #     render "tasks/index"
  #   end
  # end

  def create
    task = current_user.tasks.find_by(id:params[:task_id])
    group = Group.find_by(id:params[:group_id])

    if !task.nil? && (current_user.group == group)
      group.tasks << task
      flash[:success] = "Publich task: '#{task.title}' to group(#{current_user.group.name})! "
      redirect_to group_tasks_path
    else
      flash[:danger] = "something is wrong! not your task"
      render "tasks/index"
    end
  end

  def destroy
    task = current_user.tasks.find_by(id:params[:task_id])
    group = Group.find_by(id:params[:group_id])
    # debugger
    if group.tasks.destroy(task)
      # group.tasks.find_by(id:task.id).destroy
      # current_user.group.tasks.find_by(params[:task_id]).destroy
      flash[:success] = "withdrew task: '#{task.title}' disclosure from group(#{group.name})!"
      # debugger
      redirect_to group_tasks_path
    else
      flash[:danger] = "something is wrong! cannot deleted."
      render "index"
    end
    # mada dekite hennde
    # user = User.find(params[:user_id])
    # if (user == current_user) && (task = user.tasks.find(params[:task_id]))
    #   if user.group.tasks.destroy(task)
    #     flash[:success] = "Withdrew task: '#{task.title}' disclosure from group(#{user.group.name}!)"
    #     redirect_to group_tasks_path
    #   else
    #     flash[:danger] = "something is wrong! cannot deleted."
    #     render "index"
    #   end
    #   # flash[:infor] = "hier ist group_tasks im destroy"
    #   # render "index"
    # else
    #   flash[:danger] = "something is wrong! not your task"
    #   render "tasks/index"
    # end
  end

  private
    def get_task_user_etc

    end
end
