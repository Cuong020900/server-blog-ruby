class PostsController < ApplicationController
  skip_before_action :authorized, only: [:index, :show, :top_trending]
  before_action :set_post, only: [:update, :destroy]
  def index
    @posts = Post.joins('INNER JOIN users ON users.id = posts.cuid').select('users.username, users.name, users.avatar, posts.title, posts.id, posts.view').reverse_order()
    render json: { data: @posts }, status: :accepted
  end

  def post_by_condition
    condition = ""
    if post_condition[:word]
      condition += "posts.title LIKE '%#{post_condition[:word]}%' OR posts.content LIKE '%#{post_condition[:word]}%'"
    end
    @posts = Post.joins('INNER JOIN users ON users.id = posts.cuid').where(condition).select('users.username, users.name, users.avatar, posts.title, posts.id, posts.view').reverse_order()
    render json: { data: @posts }, status: :accepted
  end

  def show
    @post = Post.joins('INNER JOIN users ON users.id = posts.cuid').joins('LEFT JOIN series_posts on series_posts.id = posts.series_post_id').select('users.username, users.avatar, posts.*, series_posts.*').order('posts.created_at DESC').find(params[:id])

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

  def my_post
    @posts = Post.joins('INNER JOIN users ON users.id = posts.cuid').select('users.username, users.avatar, posts.title, posts.id, posts.view').where("posts.cuid = #{@current_user_id}")
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

  def update
    if @current_user_id != @post.cuid
      render json: {message: "Bạn không đủ quyền truy cập"}, status: :forbidden
    elsif @post.update(post_params)
      render json: { post: @post }
    else
      render json: { message: @post.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    if @current_user_id != @post.cuid
      render json: {message: "Bạn không đủ quyền"}, status: :forbidden
    else
      @post.destroy
      render json: {message: "Success"}, status: :ok
    end
  end

  private

  def post_condition
    params.require(:post).permit(:id, :word, :user_id)
  end

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :content)
  end

end
