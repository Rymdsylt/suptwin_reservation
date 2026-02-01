class AdminReservationsController < ApplicationController
  before_action :require_admin
  before_action :set_reservation, only: [:show, :edit, :update, :cancel]

  def index
    @reservations = Reservation.includes(:user, :table, :time_slot)
                               .order(date: :desc, created_at: :desc)
    
    # Filter by status if provided
    if params[:status].present?
      @reservations = @reservations.where(status: params[:status])
    end

    # Filter by date if provided
    if params[:date].present?
      @reservations = @reservations.where(date: params[:date])
    end
  end

  def show
  end

  def edit
    @tables = Table.order(:capacity)
    @time_slots = TimeSlot.order(:day, :start_time)
  end

  def update
    if @reservation.update(reservation_params)
      redirect_to admin_reservations_path, notice: "Reservation updated successfully."
    else
      @tables = Table.order(:capacity)
      @time_slots = TimeSlot.order(:day, :start_time)
      render :edit, status: :unprocessable_entity
    end
  end

  def cancel
    @reservation.cancelled!
    redirect_to admin_reservations_path, notice: "Reservation cancelled successfully."
  end

  private

  def set_reservation
    @reservation = Reservation.find(params[:id])
  end

  def reservation_params
    params.require(:reservation).permit(:date, :time_slot_id, :table_id, :party_size, :contact_name, :contact_email, :contact_phone, :status)
  end
end
