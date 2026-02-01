# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Create admin user
admin = User.find_or_create_by!(email: "admin@suptwin.com") do |user|
  user.password = "admin123"
  user.role = :admin
end
puts "Admin user created: #{admin.email}"

# Create test customer
customer = User.find_or_create_by!(email: "customer@test.com") do |user|
  user.password = "customer123"
  user.role = :customer
end
puts "Test customer created: #{customer.email}"

# Create time slots (hourly from 11 AM to 10 PM)
time_slots = [
  { start: "11:00", end: "12:00" },
  { start: "12:00", end: "13:00" },
  { start: "13:00", end: "14:00" },
  { start: "14:00", end: "15:00" },
  { start: "15:00", end: "16:00" },
  { start: "16:00", end: "17:00" },
  { start: "17:00", end: "18:00" },
  { start: "18:00", end: "19:00" },
  { start: "19:00", end: "20:00" },
  { start: "20:00", end: "21:00" },
  { start: "21:00", end: "22:00" }
]

time_slots.each do |slot|
  TimeSlot.find_or_create_by!(
    start_time: Time.parse(slot[:start]),
    end_time: Time.parse(slot[:end])
  )
end
puts "#{TimeSlot.count} time slots created"

# Create tables
tables = [
  { name: "Table 1", capacity: 2 },
  { name: "Table 2", capacity: 2 },
  { name: "Table 3", capacity: 4 },
  { name: "Table 4", capacity: 4 },
  { name: "Table 5", capacity: 6 },
  { name: "Table 6", capacity: 8 }
]

tables.each do |t|
  Table.find_or_create_by!(name: t[:name]) do |table|
    table.capacity = t[:capacity]
  end
end
puts "#{Table.count} tables created"

puts "Seed data completed!"
