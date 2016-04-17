class PropertiesController < ApplicationController
  before_action :logged_in_user, only: [:new]
  before_action :correct_user,   only: []
  before_action :admin_user,     only: []
  
  def index
    _session = params[:session]
    _text = ""
    if not _session.nil?
      _text = _session[:text]
    end
    @properties = Property.where("postcode LIKE '%' || ? || '%'",_text).paginate(page: params[:page])
  end
  
  def new
    @property = Property.new
    @user = User.find(current_user)
  end
  
  def show
    @property = Property.find_by(params[:id])
    @user = User.find(current_user) if logged_in?
    @comments = @property.comments.paginate(page: params[:page])
    #@commentinguser = User.find(@comments.user_id)
    @comment = @property.comments.build if logged_in?
  end
  
  def create 
    @property = Property.new(property_params)
    if @property.save 
      redirect_to root_url
    end  
    
  end
  
  def update 
    if @property.update_attributes(property_params)
      flash[:success] = "Property updated!"
    end
  end
  
  def destroy
    Property.find(params[:id]).destroy
    flash[:success] = "Property removed!"
    redirect_to root_url
  end
  
  private
  
    def property_params
      params.require(:property).permit(:addressLine1, :addressLine2,:country ,:town, :postcode, :img)
    end
    
    #Before filters
    
    #Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    #Confirms the correct user.
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
    
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
  
end
