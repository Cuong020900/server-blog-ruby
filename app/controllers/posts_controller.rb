class PostsController < ApplicationController
  def index
    @posts = Post.joins('INNER JOIN users ON users.id = posts.cuid').select('users.username, posts.*  ')
    render json: { data: @posts }, status: :accepted
  end

  def show
    @post = Post.joins('INNER JOIN users ON users.id = posts.cuid').select('users.username, posts.*  ').find(params[:id])
    render json: {
      post: @post
    }
  end

  def create
    @post = Post.new(post_params)
    @post.cuid = @current_user_id
    @post.save!
    if @post.valid?
      render json: { post: @post }, status: :accepted
    else
      render json: { message: 'Error while save post' }, status: :internal_server_error
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :content)
  end
end
