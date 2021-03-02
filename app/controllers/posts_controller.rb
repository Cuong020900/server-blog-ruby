class PostsController < ApplicationController
  skip_before_action :authorized, only: [:index, :show]
  def index
    @posts = Post.joins('INNER JOIN users ON users.id = posts.cuid').select('users.username, posts.title, posts.id, posts.view')
    render json: { data: @posts }, status: :accepted
  end

  def show
    @post = Post.joins('INNER JOIN users ON users.id = posts.cuid').select('users.username, posts.*  ').order('posts.created_at DESC').find(params[:id])

    t_post = Post.find(params[:id])
    t_post.update(view: t_post.view + 1)

    related_posts = Post.joins('INNER JOIN users ON users.id = posts.cuid').where("posts.cuid = #{@post.cuid}")
                        .select('users.username, posts.title, posts.view, posts.id')
    render json: {
      post: @post,
      related: related_posts
    }
  end

  def top_trending
    @posts = Post.joins('INNER JOIN users ON users.id = posts.cuid').select('users.username, posts.title, posts.id, posts.view')
                 .order(view: :desc).limit(10)
    render json: { data: @posts }, status: :ok
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
