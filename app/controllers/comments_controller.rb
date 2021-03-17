class CommentsController < ApplicationController
  skip_before_action :authorized, only: [:show]

  def show
    @list_cmt = Comment.joins('INNER JOIN users ON users.id = comments.cuid').where("comments.post_id = #{params[:id]}").select('users.username, users.avatar, comments.*')
    render json: { data: @list_cmt }, status: :accepted
  end

  def create
    @comment = Comment.new(create_cmt_params)
    if (create_cmt_params[:pid] != nil)
      @comment.post_id = Comment.find(create_cmt_params[:pid]).post_id
    end
    @comment.cuid = @current_user_id
    @comment.save!
    if @comment.valid?
      render json: { comment: @comment }, status: :accepted
    else
      render json: { message: 'Error while save comment' }, status: :internal_server_error
    end
  end

  private

  def create_cmt_params
    params.require(:comment).permit(:post_id, :pid, :content, :star)
  end

  def get_cmt_params
    params.require(:comment).permit(:post_id)
  end
end
