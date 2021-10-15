class TasksController < ApplicationController
  before_action :logged_in_user
  before_action :get_task,only:[:show,:edit,:update,:destroy]

  def index
    @title = "All Tasks"
    @tasks = current_user.tasks.all
    # kaminari .page(params[:page])
    # views <%= paginate @tasks %>
  end

  def show
  end

  def new
    @task = current_user.tasks.new()
  end

  def create
    @task = current_user.tasks.new(task_params)
    if @task.save
      flash[:success] = "#{@task.title} created!"
      redirect_to tasks_path
    else
      render "new"
    end
  end

  def edit
  end

  def update
    if @task.update(task_params)
      flash[:success] = "#{@task.title} updated!"
      redirect_to tasks_path
    else
      render "edit"
    end
  end

  def destroy
    if @task.destroy
      flash[:success] = "#{@task.title} deleted."
      redirect_to tasks_path
    else
      render "index"
    end
  end

  private
    def get_task
      @task = current_user.tasks.find(params[:id])
    end

    def task_params
      params.require(:task).permit(:title,:content)
    end
end
