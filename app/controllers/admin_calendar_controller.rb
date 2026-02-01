class AdminCalendarController < ApplicationController
  before_action :require_admin

  def index
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
    @start_of_week = @date.beginning_of_week
    @end_of_week = @date.end_of_week
    @week_dates = (@start_of_week..@end_of_week).to_a

    @time_slots = TimeSlot.order(:start_time)
    @tables = Table.all

    @reservations = Reservation.where(date: @start_of_week..@end_of_week)
                               .where.not(status: :cancelled)
                               .includes(:table, :time_slot, :user)

    @availability = {}
    @week_dates.each do |date|
      @availability[date] = {}
      @time_slots.each do |slot|
        reserved_count = @reservations.select { |r| r.date == date && r.time_slot_id == slot.id }.count
        total_tables = @tables.count
        @availability[date][slot.id] = {
          reserved: reserved_count,
          available: total_tables - reserved_count,
          total: total_tables
        }
      end
    end
  end
end
