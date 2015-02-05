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
    rec_legendaries_so_far.each do |run|
      legendary_count_array << run.legendary_count
    end
    @legendaries_so_far = legendary_count_array.inject{|sum,x| sum + x }

    rec_time_spent_in_rifts = Run.where(["toon_id = ?", params[:id]]).select("duration")
    time_spent_in_rift_array = []
    rec_time_spent_in_rifts.each do |run|
      p run.duration
      time_spent_in_rift_array << run.duration
    end
    @time_spent_in_rifts = time_spent_in_rift_array.inject{|sum,x| sum + x }
    if @legendaries_so_far != nil then
      @overall_legendery_found_per_hour = (3600 * @legendaries_so_far) / @time_spent_in_rifts
    else
      @overall_legendery_found_per_hour = "N/A"
    end

    rec_blood_shards_so_far = Run.where(["toon_id = ? and blood_shard_count is not null", params[:id]]).select("blood_shard_count")
    blood_shard_count_array = []
    rec_blood_shards_so_far.each do |run|
      blood_shard_count_array << run.blood_shard_count
    end
    @blood_shards_so_far = blood_shard_count_array.inject{|sum,x| sum + x }

    if @blood_shards_so_far != nil then
      @overall_blood_shards_per_hour = (3600 * @blood_shards_so_far) / @time_spent_in_rifts
    else
      @overall_blood_shards_per_hour = "N/A"
    end

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
