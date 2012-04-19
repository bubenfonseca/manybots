class VisualizationsController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @visualizations = ClientApplication.visualizations#.are_trusted
    # @my_visualizations = current_user.client_applications.where(:app_type => 'Visualization')
  end
  
  def show
    @inline = false
    if params[:aggregation_id].present?
      @inline = true
      session.delete :current_aggregations
      session[:current_aggregation] = params[:aggregation_id] 
    else
      session.delete :current_aggregation
    end
    
    if params[:bundle_id].present?
      @inline = true
      session.delete :current_aggregation
      session[:current_aggregations] = CGI.unescape params[:bundle_id] 
    else
      session.delete :current_aggregations
    end
    
    @visualization = ClientApplication.where(:app_type => 'Visualization').where(:id => params[:id]).first
    logger.info "SESSION #{session.inspect}"
  end
  
  def new
    @visualization = current_user.client_applications.new
    @visualization.app_type = 'Visualization'
  end
  
  def create
    @visualization = current_user.client_applications.build(params[:client_application])
    
    if @visualization.save
      flash[:notice] = "Visualization created."
      redirect_to :action => "show", :id => @visualization.id
    else
      render :action => "new"
    end
  end
  
  def update
    @visualization = ClientApplication.find(params[:id])
    if @visualization.update_attributes(params[:client_application])
      flash[:notice] = "Visualization updated."
      redirect_to :action => "show", :id => @visualization.id
    else
      render :action => "edit"
    end
  end
  
  
  def edit
    @visualization = ClientApplication.find(params[:id])
  end
  
  def destroy
    @visualization = current_user.client_applications.find(params[:id])
    @visualization.destroy
    redirect_to visualizations_path, :notice => 'Visualization deleted.'
  end
end
