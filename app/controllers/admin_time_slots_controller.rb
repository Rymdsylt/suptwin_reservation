class AdminTimeSlotsController < ApplicationController
  before_action :require_admin

  def index
    @time_slots = TimeSlot.order(:start_time)
  end

  def new
    @time_slot = TimeSlot.new
  end

  def create
    @time_slot = TimeSlot.new(time_slot_params)
    if @time_slot.save
      redirect_to admin_time_slots_path, notice: 'Time slot created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @time_slot = TimeSlot.find(params[:id])
  end

  def update
    @time_slot = TimeSlot.find(params[:id])
    if @time_slot.update(time_slot_params)
      redirect_to admin_time_slots_path, notice: 'Time slot updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @time_slot = TimeSlot.find(params[:id])
    @time_slot.destroy
    redirect_to admin_time_slots_path, notice: 'Time slot deleted.'
  end

  private

  def time_slot_params
    params.require(:time_slot).permit(:start_time, :end_time)
  end
end
