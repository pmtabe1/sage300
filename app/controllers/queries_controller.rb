# The QueryController are create to explore data with SQL.
# Create dynamic tables using ag-Grid to easy analyzed and share.
class QueriesController < ApplicationController
  before_action :set_query, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # Standard Rails index action, we use cancancan for permissions.
  def index
    authorize! :index, Query
    @queries = Query.all
  end

  # Show action rendered as json fro ag-Grid and exec_query.
  def show
    authorize! :read, @query
    @result = ActiveRecord::Base.connection.exec_query(@query.statement)
    @columns = @result.columns
    @rows = @result.rows
    respond_to do |format|
      format.html
      format.json { render json: @result.to_a }
    end
  end

  # Standard Rails edit action, we use cancancan for permissions.
  def edit
    authorize! :update, @query
  end

  # Standard Rails edit action, we use cancancan for permissions.
  def new
    authorize! :create, @query = Query.new
  end

  # Create action with multi commit params to Run query without
  # saved it into database.
  def create
    @query = current_user.queries.build(query_params)
    respond_to do |format|
      if params[:commit] == 'Run'
        @result = ActiveRecord::Base.connection.exec_query(@query.statement)
        @columns = @result.columns
        @rows = @result.rows
        format.js
      else
        if @query.save
          format.html { redirect_to queries_path }
        else
          format.html { render :new }
        end
      end
    end
  end

  # Update action with multi commit params to Run query without
  # before update it.
  def update
    respond_to do |format|
      if params[:commit] == 'Run'
        @query = Query.new(query_params)
        @result = ActiveRecord::Base.connection.exec_query(@query.statement)
        @columns = @result.columns
        @rows = @result.rows
        format.js
      else
        if @query.update(query_params)
          format.html { redirect_to queries_path }
        else
          format.html { render :edit }
        end
      end
    end
  end

  # Custom action to display all tables, columns and column types of Sage300
  # database.
  def schema
    @schema = ActiveRecord::Base.connection.tables
  end

  # Standard Rails edit action, we use cancancan for permissions.
  def destroy
    authorize! :destroy, @query
    @query.destroy
    respond_to do |format|
      format.html { redirect_to queries_url, notice: 'Query successfully deleted.' }
    end
  end

  private
    def set_query
      @query = Query.friendly.find(params[:id])
    end

    def query_params
      params.require(:query).permit(:name, :description, :statement, :module)
    end
end
