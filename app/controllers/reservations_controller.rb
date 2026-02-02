class ReservationsController < ApplicationController
  before_action :require_login, except: [:availability]

  def availability
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
    @time_slots = TimeSlot.where(day: @date.strftime("%A")).order(:start_time)
    @tables = Table.all.order(:name)

    @reservations = Reservation.where(date: @date).where.not(status: :cancelled)

    @availability = {}
    now = Time.zone.now
    @time_slots.each do |slot|
      slot_datetime = Time.zone.local(@date.year, @date.month, @date.day, slot.start_time.hour, slot.start_time.min)
      if @date == Date.today && slot_datetime <= now + 2.hours
        @availability[slot.id] = []
        next
      end
      reserved_table_ids = @reservations.where(time_slot: slot).pluck(:table_id)
      available_tables = @tables.where.not(id: reserved_table_ids)
      @availability[slot.id] = available_tables
    end
  end

  def new
    @reservation = Reservation.new
    @reservation.date = params[:date]
    @reservation.time_slot_id = params[:time_slot_id]

    @time_slot = TimeSlot.find_by(id: params[:time_slot_id])
    @date = params[:date] ? Date.parse(params[:date]) : Date.today

    # Get available tables for this slot
    reserved_table_ids = Reservation.where(date: @date, time_slot_id: @time_slot&.id)
                                    .where.not(status: :cancelled)
                                    .pluck(:table_id)
    @available_tables = Table.where.not(id: reserved_table_ids).order(:name)

    # Auto-fill contact details for logged-in users
    if current_user
      @reservation.contact_email = current_user.email
    end
  end

  def create
    @reservation = current_user.reservations.build(reservation_params)
    @reservation.status = :confirmed

    if @reservation.save
      redirect_to reservation_path(@reservation), notice: "Reservation confirmed!"
    else
      @time_slot = @reservation.time_slot
      @date = @reservation.date || Date.today
      reserved_table_ids = Reservation.where(date: @date, time_slot_id: @time_slot&.id)
                                      .where.not(status: :cancelled)
                                      .pluck(:table_id)
      @available_tables = Table.where.not(id: reserved_table_ids).order(:name)
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @reservation = current_user.reservations.find(params[:id])
  end

  def index
    @reservations = current_user.reservations.includes(:table, :time_slot)
                                .order(date: :desc, created_at: :desc)
  end

  def cancel
    @reservation = current_user.reservations.find(params[:id])

    reservation_datetime = DateTime.new(
      @reservation.date.year, @reservation.date.month, @reservation.date.day,
      @reservation.time_slot.start_time.hour, @reservation.time_slot.start_time.min
    )

    if reservation_datetime < 2.hours.from_now
      redirect_to my_reservations_path, alert: "Cannot cancel reservation less than 2 hours before the booking time."
    else
      @reservation.cancelled!
      redirect_to my_reservations_path, notice: "Reservation cancelled successfully."
    end
  end

  private

  def reservation_params
    params.require(:reservation).permit(:date, :time_slot_id, :table_id, :party_size, :contact_name, :contact_phone, :contact_email)
  end
end
