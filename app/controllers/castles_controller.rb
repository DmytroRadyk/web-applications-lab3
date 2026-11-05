class CastlesController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_castle, only: %i[show]
  before_action :set_owned_castle, only: %i[edit update destroy]

  def index
    @regions = Castle.distinct.order(:region).pluck(:region)
    @castles = Castle.includes(:user).order(created_at: :desc)
    @castles = @castles.where(region: params[:region]) if params[:region].present?
    if params[:q].present?
      query = "%#{Castle.sanitize_sql_like(params[:q].strip.downcase)}%"
      @castles = @castles.where("search_text LIKE ?", query)
    end
  end

  def show; end
  def new
    @castle = current_user.castles.new
  end
  def edit; end

  def create
    @castle = current_user.castles.new(castle_params)
    if @castle.save
      redirect_to @castle, notice: "Замок додано до колекції."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @castle.update(castle_params)
      redirect_to @castle, notice: "Зміни збережено."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @castle.destroy!
    redirect_to castles_path, notice: "Запис видалено.", status: :see_other
  end

  private
  def set_castle
    @castle = Castle.find(params[:id])
  end
  def set_owned_castle
    @castle = Castle.find(params[:id])
    head :forbidden unless @castle.user_id == current_user.id
  end
  def castle_params
    params.require(:castle).permit(:name, :region, :location, :description, :built_year)
  end
end
