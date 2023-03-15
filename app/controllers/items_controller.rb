class ItemsController < ApplicationController
  before_action :find_user

  def index
    items = @user.items
    render json: items, include: :user
  end

  def show
    item = @user.items.find_by(id: params[:id])
    if item
      render json: item, include: :user
    else
      render json: { error: "Item not found" }, status: :not_found
    end
  end

  def create
    item = @user.items.new(item_params)
    if item.save
      render json: item, status: :created
    else
      render json: { error: item.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :price)
  end

  def find_user
    @user = User.find_by(id: params[:user_id])
    render json: { error: "User not found" }, status: :not_found unless @user
  end
end
