class PostsController < ApplicationController
  skip_before_action :authorized, only: [:index, :show, :top_trending]
  before_action :set_post, only: [:update, :destroy]
  def index
    @posts = Post.joins('INNER JOIN users ON users.id = posts.cuid').joins('LEFT JOIN comments ON posts.id = comments.post_id').group('posts.id').select('users.username, users.name, users.avatar, posts.title, posts.tags, posts.id, posts.view, COUNT(comments.id) as cmt_count').reverse_order()
    render json: { data: @posts }, status: :accepted
  end

  def post_by_condition
    condition = ""
    if post_condition[:word]
      condition += "posts.title LIKE '%#{post_condition[:word]}%' OR posts.content LIKE '%#{post_condition[:word]}%'"
    end
    @posts = Post.joins('INNER JOIN users ON users.id = posts.cuid').where(condition).select('users.username, users.name, users.avatar, posts.title, posts.tags, posts.id, posts.view').reverse_order()
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
    @posts = Post.joins('INNER JOIN users ON users.id = posts.cuid').select('users.username, posts.title, posts.id, posts.tags, posts.view')
                 .order(view: :desc).limit(10)
    render json: { data: @posts }, status: :ok
  end

  def my_post
    @posts = Post.joins('INNER JOIN users ON users.id = posts.cuid').joins('LEFT JOIN comments ON posts.id = comments.post_id').group('posts.id').select('users.username, users.avatar, posts.title, posts.tags, posts.id, posts.view, COUNT(comments.id) as cmt_count').where("posts.cuid = #{params[:id]}")
    render json: { data: @posts }, status: :ok
  end

  def find_post
    if find_post_params[:tag] == "" && find_post_params[:content] == ""
      @posts = Post.joins('INNER JOIN users ON users.id = posts.cuid').joins('LEFT JOIN comments ON posts.id = comments.post_id').group('posts.id').select('users.username, users.name, users.avatar, posts.title, posts.tags, posts.id, posts.view, COUNT(comments.id) as cmt_count').reverse_order()
    elsif find_post_params[:content] == ""
      @posts = Post.joins('INNER JOIN users ON users.id = posts.cuid').joins('LEFT JOIN comments ON posts.id = comments.post_id').group('posts.id').select('users.username, users.avatar, posts.title, posts.tags, posts.id, posts.view, COUNT(comments.id) as cmt_count')
                  .where("JSON_CONTAINS(posts.tags, json_quote('#{find_post_params[:tag]}'), '$')")
    elsif find_post_params[:tag] == ""
      @posts = Post.joins('INNER JOIN users ON users.id = posts.cuid').joins('LEFT JOIN comments ON posts.id = comments.post_id').group('posts.id').select('users.username, users.avatar, posts.title, posts.tags, posts.id, posts.view, COUNT(comments.id) as cmt_count')
      .where("posts.title LIKE '%#{find_post_params[:content]}%'")
    else
      @posts = Post.joins('INNER JOIN users ON users.id = posts.cuid').joins('LEFT JOIN comments ON posts.id = comments.post_id').group('posts.id').select('users.username, users.avatar, posts.title, posts.tags, posts.id, posts.view, COUNT(comments.id) as cmt_count')
      .where("posts.title LIKE '%#{find_post_params[:content]}%' AND JSON_CONTAINS(posts.tags, json_quote('#{find_post_params[:tag]}'), '$')")
    end                  
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

  def clip_post
    @clip = Clip.new(clip_post_params)
    @clip.user_id = @current_user_id
    @clip.save!
    if @clip.valid?
      render json: { clip: @clip }, status: :accepted
    else
      render json: { message: 'Error while save clip' }, status: :internal_server_error
    end
  end

  def my_clips
    @posts = Post.joins('INNER JOIN users ON users.id = posts.cuid')
    .joins('LEFT JOIN comments ON posts.id = comments.post_id')
    .joins('INNER JOIN clips ON posts.id = clips.post_id')
    .where("clips.user_id = #{@current_user_id}")
    .group('posts.id')
    .select('users.username, users.name, users.avatar, posts.title, posts.tags, posts.id, posts.view, COUNT(comments.id) as cmt_count').reverse_order()
    render json: { data: @posts }, status: :accepted
  end

  private

  def post_condition
    params.require(:post).permit(:id, :word, :user_id)
  end

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :content, :tags => [])
  end

  def find_post_params
    params.require(:post).permit(:content, :tag)
  end

  def clip_post_params
    params.require(:post).permit(:post_id)
  end

end
