class ToonsController < ApplicationController
  before_action :set_toon, only: [:show, :edit, :update, :destroy]

  respond_to :html
  def index
    if !current_user
      redirect_to new_user_session_path, notice: 'You are not logged in.'
    else
      @toons = Toon.where(["user_id = ?", current_user.id]).order("name")
      respond_with(@toons)
    end
  end

  def show
    @runs_for_toon = Run.where(["toon_id = ?", params[:id]]).count
    rec_legendaries_so_far = Run.where(["toon_id = ? and legendary_count is not null", params[:id]]).select("legendary_count")
    legendary_count_array = []
    rec_legendaries_so_far.each do |legendary_count|
      legendary_count_array << legendary_count.legendary_count
    end
    @legendaries_so_far = legendary_count_array.inject{|sum,x| sum + x }
    respond_with(@toon)
  end

  def new
    if !current_user
      redirect_to new_user_session_path, notice: 'You are not logged in.'
    else
      @toon = Toon.new
      @archetypes = Archetype.all.order("name")
      respond_with(@toon)
    end
  end

  def edit
    @archetypes = Archetype.all.order("name")
  end

  def create
    @toon = Toon.new(toon_params)
    @toon.user_id = current_user.id
    @toon.save
    respond_with(@toon)
  end

  def update
    @toon.update(toon_params)
    respond_with(@toon)
  end

  def destroy
    @toon.destroy
    respond_with(@toon)
  end

  private

  def set_toon
    @toon = Toon.find(params[:id])
  end

  def toon_params
    params.require(:toon).permit(:name, :archetype_id, :user_id)
  end
end
