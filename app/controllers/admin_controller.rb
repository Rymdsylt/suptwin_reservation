class AdminController < ApplicationController
  before_action :require_admin

  def dashboard
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
    @reservations_today = Reservation.where(date: @date).includes(:user, :table, :time_slot)
    @reservations_week = Reservation.where(date: @date.beginning_of_week..@date.end_of_week).includes(:user, :table, :time_slot)
    @reservations_month = Reservation.where(date: @date.beginning_of_month..@date.end_of_month).includes(:user, :table, :time_slot)
    @total_tables = Table.count
    @total_time_slots = TimeSlot.count
    @total_reservations = Reservation.count
    @upcoming_reservations = Reservation.where('date >= ?', Date.today).order(:date, :time_slot_id).limit(10)
  end
end
