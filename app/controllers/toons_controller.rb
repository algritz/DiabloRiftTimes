# Controller, where Character stats will be compiled in relation
# to properties of each runs this specific character completed
class ToonsController < ApplicationController
  before_action :signed_in?
  before_action :set_toon, only: [:show, :edit, :update, :destroy]
  before_action :user_owner?, only: [:show, :edit, :update, :destroy]

  respond_to :html
  def index
    if !current_user
      redirect_to new_user_session_path, notice: 'You are not logged in.'
    else
      @toons = Toon.where(['user_id = ?', current_user.id]).order('name')
      respond_with(@toons)
    end
  end

  def show
    @runs_for_toon = Run.where(['toon_id = ?', params[:id]]).count

    rec_legendaries_so_far = Run.where(['toon_id = ? and
                                         legendary_count is not null',
                                        params[:id]]).select('id',
                                                             'legendary_count')

    @leg_so_far = get_array_total(rec_legendaries_so_far, 'legendary_count')

    rec_time_spent_in_rifts = Run.where(['toon_id = ?',
                                         params[:id]]).select('id', 'duration')

    @time_spent_in_rifts = get_array_total(rec_time_spent_in_rifts, 'duration')

    @overall_leg_per_hour = (3600 * @leg_so_far) /
                            @time_spent_in_rifts unless @leg_so_far.nil?

    rec_blood_shards_so_far = Run.where(['toon_id = ? and
                                          blood_shard_count is not null',
                                         params[:id]]
                                       ).select('blood_shard_count')

    @bs_so_far = get_array_total(rec_blood_shards_so_far, 'blood_shard_count')

    @overall_bs_per_hour = (3600 * @bs_so_far) /
                           @time_spent_in_rifts unless @bs_so_far.nil?

    respond_with(@toon)
  end

  def new
    if !current_user
      redirect_to new_user_session_path, notice: 'You are not logged in.'
    else
      @toon = Toon.new
      @archetypes = Archetype.all.order('name')
      respond_with(@toon)
    end
  end

  def edit
    @archetypes = Archetype.all.order('name')
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

  def signed_in?
    redirect_to(new_user_session_path) if current_user.nil?
  end

  def user_owner?
    redirect_to(toons_path,
                notice: 'Only authorized users can access this page') if
                                              @toon.user_id != current_user.id
  end
end
