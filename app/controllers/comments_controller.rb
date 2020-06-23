class CommentsController < ApplicationController
  def index
    if check_owner
      render "index"
    end
  end

  def create
    Comment.create!(
      order_id: params[:id],
      rating: params[:rating],
      comment: params[:comment],
    )
    redirect_to orders_path
  end
end
