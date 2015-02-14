# Runs Controller, handles the CRUD operation to the Run Model
# Each Runs represents a rift that was completed by the player
# this class is the backbone of the application, this is where most of the
# analytics will be drawn from
class RunsController < ApplicationController
  before_action :signed_in?
  before_action :set_run, only: [:show, :edit, :update, :destroy]
  before_action :user_owner?, only: [:show, :edit, :update, :destroy]
  # GET /runs
  # GET /runs.json
  def index
    @toons = Toon.where(['user_id = ?', current_user.id]).select('id, name')
    @difficulties = Difficulty.all.order('id')

    return @runs = Run.paginate(:page => params[:page], :per_page => 20).where(
                                                                 ['user_id = ?',
                              current_user.id]).order('difficulty_id desc,
                                toon_id') if
                                (params[:context].nil? ||
                                params[:context].to_i == 0) &&
                                (params[:difficulty].nil? ||
                                params[:difficulty].to_i == 0)
    return @runs = Run.paginate(:page => params[:page], :per_page => 20).where(
                                               ['toon_id = ?', params[:context]]
               ).order('difficulty_id desc') if
                               (!params[:context].nil? &&
                               params[:context].to_i > 0) &&
                               (params[:difficulty].nil? ||
                               params[:difficulty].to_i == 0)
    return @runs = Run.paginate(:page => params[:page], :per_page => 20).where(
                                           ['toon_id = ? and difficulty_id = ?',
                              params[:context],
                            params[:difficulty]]
               ).order('difficulty_id desc') if
                            (!params[:context].nil? &&
                            params[:context].to_i > 0) &&
                            (!params[:difficulty].nil? ||
                            params[:difficulty].to_i > 0)
    return @runs = Run.paginate(:page => params[:page], :per_page => 20).where(
                                           ['user_id = ? and difficulty_id = ?',
                              current_user.id,
                              params[:difficulty]]).order('difficulty_id desc,
                              toon_id') if
                              (params[:context].nil? ||
                              params[:context].to_i == 0) &&
                              (!params[:difficulty].nil? ||
                              params[:difficulty].to_i > 0)
  end

  # GET /runs/1
  # GET /runs/1.json
  def show
    @duration = Run.where(['toon_id = ? and
                            difficulty_id = ? and
                            player_count = ?',
                           @run.toon_id,
                           @run.difficulty_id,
                           @run.player_count]
                         ).order('id desc').last(10)
    @leg_count = Run.where(['toon_id = ? and
                             difficulty_id = ? and
                             player_count = ? and
                             legendary_count is not null',
                            @run.toon_id,
                            @run.difficulty_id,
                            @run.player_count]
                          ).select('id, legendary_count').last(10)
    @bs_count = Run.where(['toon_id = ? and
                            difficulty_id = ? and
                            player_count = ? and
                            blood_shard_count is not null',
                           @run.toon_id,
                           @run.difficulty_id,
                           @run.player_count]
                                   ).select('id', 'blood_shard_count').last(10)
    @duration_fc = Run.where(['toon_id = ? and
                               difficulty_id = ? and
                               player_count = ? and
                               duration_full_clear > 0',
                              @run.toon_id,
                              @run.difficulty_id,
                              @run.player_count]
                                  ).select('id', 'duration_full_clear').last(10)
    @leg_count_fc = Run.where(['toon_id = ? and
                                difficulty_id = ?
                                and player_count = ?
                                and legendary_count_full_clear is not null',
                               @run.toon_id,
                               @run.difficulty_id,
                               @run.player_count]
                          ).select('id', 'legendary_count_full_clear').last(10)
    @bs_count_fc = Run.where(['toon_id = ? and
                               difficulty_id = ? and
                               player_count = ? and
                               blood_shard_count_full_clear is not null',
                              @run.toon_id,
                              @run.difficulty_id,
                              @run.player_count]
                         ).select('id', 'blood_shard_count_full_clear').last(10)

    @total_time = get_array_total(@duration, 'duration')

    @avg_duration = @total_time / @duration.count
    
    @ready_for_next_difficulty = Run.where(['toon_id = ? and
                                             difficulty_id = ? and
                                             player_count = ? and
                                             duration < ?',
                                           @run.toon_id,
                                           @run.difficulty_id,
                                           @run.player_count,
                                           @avg_duration
                                           ]).count
    
    @target_time = TargetTime.where(['player_count = ? and difficulty_id = ?',
                                     @run.player_count,
                                     @run.difficulty_id]).select('id,
                                  target_time').first

    @total_leg_count = get_array_total(@leg_count, 'legendary_count')

    @avg_leg_count = @total_leg_count / @leg_count.count if @leg_count.count > 0

    @leg_per_hour =  (@total_leg_count * 3600) / @total_time if
                                  !@total_leg_count.nil? && @total_leg_count > 0

    @total_bs_count = get_array_total(@bs_count, 'blood_shard_count')

    @avg_bs_count = @total_bs_count / @bs_count.count if
                                                      @bs_count.count > 0

    @bs_per_hour =  (@total_bs_count * 3600) / @total_time if
                                    !@total_bs_count.nil? && @total_bs_count > 0

    @total_time_fc = get_array_total(@duration_fc, 'duration_full_clear')

    @avg_duration_fc = @total_time_fc / @duration_fc.count if
                                                          @duration_fc.count > 0

    @total_leg_count_fc = get_array_total(@leg_count_fc,
                                          'legendary_count_full_clear')

    @avg_leg_count_fc = @total_leg_count_fc / @leg_count_fc.count if
                                                         @leg_count_fc.count > 0

    @leg_per_hour_fc =  (@total_leg_count_fc * 3600) / @total_time_fc if
                           !@total_leg_count_fc.nil? && @total_leg_count_fc > 0

    @total_bs_count_fc = get_array_total(@bs_count_fc,
                                         'blood_shard_count_full_clear')

    @avg_bs_count_fc = @total_bs_count_fc / @bs_count_fc.count if
                                                          @bs_count_fc.count > 0

    @bs_per_hour_fc =  (@total_bs_count_fc * 3600) / @total_time_fc if
                           !@total_bs_count_fc.nil? && @total_bs_count_fc > 0
  end

  # GET /runs/new
  def new
    @toons = Toon.where(['user_id = ?', current_user.id]).order('name')
    @difficulty = Difficulty.all.order('id')
    @run = Run.new
  end

  # GET /runs/1/edit
  def edit
    @toons = Toon.where(['user_id = ?', current_user.id]).order('name')
    @difficulty = Difficulty.all.order('id')
  end

  # POST /runs
  # POST /runs.json
  def create
    @run = Run.new(run_params)
    @run.user_id = current_user.id
    @run.duration = convert_to_seconds(run_params, 'duration')
    @run.duration_full_clear = convert_to_seconds(run_params,
                                                  'duration_full_clear')
    respond_to do |format|
      if @run.save
        format.html do
          redirect_to @run,
                      notice: 'Run was successfully created.'
        end
        format.json { render :show, status: :created, location: @run }
      else
        format.html { render :new }
        format.json { render json: @run.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /runs/1
  # PATCH/PUT /runs/1.json
  def update
    respond_to do |format|
      if @run.update(run_params)
        format.html do
          redirect_to @run, notice: 'Run was successfully updated.'
        end
        format.json { render :show, status: :ok, location: @run }
      else
        format.html { render :edit }
        format.json { render json: @run.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /runs/1
  # DELETE /runs/1.json
  def destroy
    @run.destroy
    respond_to do |format|
      format.html do
        redirect_to runs_url,
                    notice: 'Run was successfully destroyed.'
      end
      format.json { head :no_content }
    end
  end

  private

  # make sure the user is signed in, don't want lurkers here
  def signed_in?
    redirect_to(new_user_session_path) if current_user.nil?
  end

  # make sure users can only see their stuff, unless they are admins
  def user_owner?
    redirect_to(runs_path,
                notice: 'Only authorized users can access this page') if
                @run.user_id != current_user.id
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_run
    @run = Run.find(params[:id])
  end

  # Never trust parameters from the scary internet,
  # only allow the white list through.
  def run_params
    params.require(:run).permit(:duration,
                                :legendary_count,
                                :blood_shard_count,
                                :duration_full_clear,
                                :legendary_count_full_clear,
                                :blood_shard_count_full_clear,
                                :user_id,
                                :toon_id,
                                :difficulty_id,
                                :player_count,
                                :context)
  end
end
