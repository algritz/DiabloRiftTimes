# This Controller, handles the CRUD elements for the Target Times Model
# Each record derives form the combination of a difficulty level and
# the number of players in the group
class TargetTimesController < ApplicationController
  before_action :admin?
  before_action :set_target_time, only: [:show, :edit, :update, :destroy]
  # GET /target_times
  # GET /target_times.json
  def index
    @target_times = TargetTime.all.order("player_count, difficulty_id")
  end

  # GET /target_times/1
  # GET /target_times/1.json
  def show
  end

  # GET /target_times/new
  def new
    @target_time = TargetTime.new
    @difficulty = Difficulty.all.order('id')
  end

  # GET /target_times/1/edit
  def edit
    @difficulty = Difficulty.all.order('id')
  end

  # POST /target_times
  # POST /target_times.json
  def create
    @target_time = TargetTime.new(target_time_params)
    @target_time.target_time = convert_to_seconds(target_time_params,
                                                  'target_time')
    respond_to do |format|
      if @target_time.save
        format.html do
          redirect_to @target_time,
                      notice: 'Target time was successfully created.'
        end
        format.json { render :show, status: :created, location: @target_time }
      else
        format.html { render :new }
        format.json do
          render json: @target_time.errors,
                 status: :unprocessable_entity
        end
      end
    end
  end

  # PATCH/PUT /target_times/1
  # PATCH/PUT /target_times/1.json
  def update
    respond_to do |format|
      if @target_time.update(target_time_params)
        format.html do
          redirect_to @target_time,
                      notice: 'Target time was successfully updated.'
        end
        format.json { render :show, status: :ok, location: @target_time }
      else
        format.html { render :edit }
        format.json do
          render json: @target_time.errors,
                 status: :unprocessable_entity
        end
      end
    end
  end

  # DELETE /target_times/1
  # DELETE /target_times/1.json
  def destroy
    @target_time.destroy
    respond_to do |format|
      format.html do
        redirect_to target_times_url,
                    notice: 'Target time was successfully destroyed.'
      end
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_target_time
    @target_time = TargetTime.find(params[:id])
  end

  # Never trust parameters from the scary internet,
  # only allow the white list through.
  def target_time_params
    params.require(:target_time).permit(:target_time,
                                        :difficulty_id,
                                        :player_count)
  end
end
