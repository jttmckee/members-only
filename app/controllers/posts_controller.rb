class PostsController < ApplicationController
  before_action :only_member, only:[:new,:create]

  def new
    @post = Post.new(author_id:current_user.id)
  end

  def create
    @post = Post.new(post_params)
    @post.author_id = current_user.id
    if @post.save
      flash[:notice] = "Post successfully saved"
      redirect_to posts_path
    else
      render 'new'
    end
  end

  def index
    @posts = Post.all
  end

  private
    def only_member
      unless logged_in?(current_user)
        flash[:warning] = 'You must be logged in to create a post'
        redirect_to root_url
        return
      end
    end

    def post_params
      params.require(:post).permit(:title,:body)
    end
end
