class CommentsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy

  def create
    @user = User.find(current_user)
    @comment = Comment.new(comment_params)
    property = Property.find(@comment.property_id)
    if @comment.save
      redirect_to property
    else
      flash[:danger] = "Comment not added please report this to the site admin."
      redirect_to property
    end
  end
  
  def current_property
    @current_property ||= Property.find_by(params[:id])
  end
  
  def destroy
    @comment = Comment.find(params[:id])
    @property = Property.find(@comment.property_id)
    @comment.destroy
    redirect_to @property
  end
  
  private
    def comment_params
      params.require(:comment).permit(:user_id, :content, :property_id)
    end
    
    def correct_user
      @comment = Comment.find(params[:id])
      puts @comment
      redirect_to root_url if @comment.nil?
    end
end
