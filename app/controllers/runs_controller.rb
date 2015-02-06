class RunsController < ApplicationController
  before_action :signed_in?
  before_action :set_run, only: [:show, :edit, :update, :destroy]
  before_action :is_user_owner?, only: [:show, :edit, :update, :destroy]
  # GET /runs
  # GET /runs.json
  def index
    @runs = Run.where(["user_id = ?", current_user.id])
  end

  # GET /runs/1
  # GET /runs/1.json
  def show
    @duration_for_this_type = Run.where(["toon_id = ? and difficulty_id = ? and player_count = ?", @run.toon_id, @run.difficulty_id, @run.player_count]).last(10)
    @legendary_count_for_this_type = Run.where(["toon_id = ? and difficulty_id = ? and player_count = ? and legendary_count is not null", @run.toon_id, @run.difficulty_id, @run.player_count]).select("id, legendary_count").last(10)
    @blood_shard_count_for_this_type = Run.where(["toon_id = ? and difficulty_id = ? and player_count = ? and blood_shard_count is not null", @run.toon_id, @run.difficulty_id, @run.player_count]).select("id", "blood_shard_count").last(10)
    @duration_full_clear_for_this_type = Run.where(["toon_id = ? and difficulty_id = ? and player_count = ? and duration_full_clear is not null", @run.toon_id, @run.difficulty_id, @run.player_count]).select('id', 'duration_full_clear').last(10)
    @legendary_count_full_clear_for_this_type = Run.where(["toon_id = ? and difficulty_id = ? and player_count = ? and legendary_count_full_clear is not null", @run.toon_id, @run.difficulty_id, @run.player_count]).select("legendary_count_full_clear").last(10)
    @blood_shard_count_full_clear_for_this_type = Run.where(["toon_id = ? and difficulty_id = ? and player_count = ? and blood_shard_count_full_clear is not null", @run.toon_id, @run.difficulty_id, @run.player_count]).select("blood_shard_count_full_clear").last(10)

    @total_time = get_array_total(@duration_for_this_type, "duration")
    @avg_duration_for_this_type = @total_time / @duration_for_this_type.count

    @total_legendary_count = get_array_total(@legendary_count_for_this_type, "legendary_count")
    if @legendary_count_for_this_type.count > 0 then
      @avg_legendary_count_for_this_type = @total_time / @legendary_count_for_this_type.count
    else
      @avg_legendary_count_for_this_type = 0
    end

    @total_blood_shard_count = get_array_total(@blood_shard_count_for_this_type, "blood_shard_count")
    if @blood_shard_count_for_this_type.count > 0 then
      @avg_blood_shard_count_for_this_type = @total_blood_shard_count / @blood_shard_count_for_this_type.count
    else
      @avg_blood_shard_count_for_this_type = 0
    end

    @total_time_full_clear = get_array_total(@duration_full_clear_for_this_type, 'duration_full_clear')
    if @duration_full_clear_for_this_type.count > 0 then
      @avg_duration_full_clear_for_this_type = @total_time_full_clear / @duration_full_clear_for_this_type.count
    else
      @avg_duration_full_clear_for_this_type = 0
    end

    legendary_count_full_clear_array = []
    @legendary_count_full_clear_for_this_type.each do |run|
      legendary_count_full_clear_array << run.legendary_count_full_clear
    end
    if legendary_count_full_clear_array.count > 0 then
      @total_legendary_count_full_clear = legendary_count_full_clear_array.inject{|sum,x| sum + x }
      @avg_legendary_count_full_clear_for_this_type = @total_legendary_count_full_clear / legendary_count_full_clear_array.count
      if @total_time_full_clear != 0 then
        @legendary_per_hour_full_clear = (3600 * @total_legendary_count_full_clear) / @total_time_full_clear
      end
    else
      @avg_legendary_count_full_clear_for_this_type = "N/A"
      @legendary_per_hour_full_clear = "N/A"
    end

    blood_shard_count_full_clear_array = []
    @blood_shard_count_full_clear_for_this_type.each do |run|
      blood_shard_count_full_clear_array << run.blood_shard_count_full_clear
    end

    if blood_shard_count_full_clear_array.count > 0 then
      @total_blood_shard_count_full_clear = blood_shard_count_full_clear_array.inject{|sum,x| sum + x }
      @avg_blood_shard_count_full_clear_for_this_type = @total_blood_shard_count_full_clear / blood_shard_count_full_clear_array.count
      if @total_time_full_clear != 0 then
        @blood_shard_per_hour_full_clear = (3600 * @total_blood_shard_count_full_clear) / @total_time_full_clear
      end
    else
      @total_blood_shard_count_full_clear = 0
      @avg_blood_shard_count_full_clear_for_this_type = "N/A"
      @blood_shard_per_hour_full_clear = "N/A"
    end

  end

  # GET /runs/new
  def new
    @toons = Toon.where(["user_id = ?", current_user.id]).order("name")
    @difficulty = Difficulty.all.order("id")
    @run = Run.new
  end

  # GET /runs/1/edit
  def edit
    @toons = Toon.where(["user_id = ?", current_user.id]).order("name")
    @difficulty = Difficulty.all.order("id")
  end

  # POST /runs
  # POST /runs.json
  def create
    @run = Run.new(run_params)
    @run.user_id = current_user.id
    minutes_duration = run_params["duration(5i)"].to_i
    seconds_duration = run_params["duration(6i)"].to_i
    total_duration = (minutes_duration * 60) + seconds_duration
    @run.duration = total_duration
    minutes_duration_full_clear = run_params["duration_full_clear(5i)"].to_i
    seconds_duration_full_clear = run_params["duration_full_clear(6i)"].to_i
    total_duration_full_clear = (minutes_duration_full_clear * 60) + seconds_duration_full_clear
    @run.duration_full_clear = total_duration_full_clear
    respond_to do |format|
      if @run.save
        format.html { redirect_to @run, notice: 'Run was successfully created.' }
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
        format.html { redirect_to @run, notice: 'Run was successfully updated.' }
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
      format.html { redirect_to runs_url, notice: 'Run was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # make sure the user is signed in, don't want lurkers here
  def signed_in?
    if current_user == nil then
      redirect_to(new_user_session_path)
    end
  end

  #make sure users can only see their stuff, unless they are admins
  def is_user_owner?
    if @run.user_id != current_user.id then
      redirect_to(runs_path, :notice => 'Only authorized users can access this page')
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_run
    @run = Run.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def run_params
    params.require(:run).permit(:duration, :legendary_count, :blood_shard_count, :duration_full_clear, :legendary_count_full_clear, :blood_shard_count_full_clear, :user_id, :toon_id, :difficulty_id, :player_count)
  end
end
