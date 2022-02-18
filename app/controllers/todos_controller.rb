class TodosController < ApplicationController
  before_action :set_todo, only: %i[ show edit update destroy toggle ]

  # GET /todos or /todos.json
  def index
    @todos = Todo.all.order(id: :desc)
  end

  # GET /todos/1 or /todos/1.json
  def show
  end

  # GET /todos/new
  def new
    @todo = Todo.new
  end

  # GET /todos/1/edit
  def edit
  end
  
  def toggle
    @todo.update(completed: !@todo.completed)
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(@todo, partial: "todo", locals: {todo: @todo})
      end
    end
  end

  # POST /todos or /todos.json
  def create
    @todo = Todo.new(todo_params)

    respond_to do |format|
      if @todo.save
        flash.now[:notice] = "Todo created"
        format.html { redirect_to @todo, notice: "Todo was successfully created." }
        format.json { render :show, status: :created, location: @todo }
        format.turbo_stream { render layout: 'application' }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @todo.errors, status: :unprocessable_entity }
        format.turbo_stream do
          render turbo_stream: turbo_stream.update('create-todo', partial: "form", locals: {todo: @todo, css_classes: "fade-in-left"})
        end
      end
    end
  end

  # PATCH/PUT /todos/1 or /todos/1.json
  def update
    respond_to do |format|
      if @todo.update(todo_params)
        format.html { redirect_to @todo, notice: "Todo was successfully updated." }
        format.json { render :show, status: :ok, location: @todo }
        format.turbo_stream do
          render turbo_stream: turbo_stream.update(@todo, partial: "todo", locals: {todo: @todo})
        end
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @todo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /todos/1 or /todos/1.json
  def destroy
    @todo.destroy

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@todo) }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_todo
      @todo = Todo.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def todo_params
      params.require(:todo).permit(:content, :completed)
    end
end
