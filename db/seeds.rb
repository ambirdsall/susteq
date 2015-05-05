require 'faker'

LAT_MIN = -1.377018 # South of Nairobi
LAT_MAX = -1.219302 # North of Nairobi
LONG_MIN = 36.636440 # West of Nairobi
LONG_MAX = 36.959850 # East of Nairobi

class HubLocationID
  @@id = 0

  def self.next
    @@id += 1
  end
end

def generate_random_lat_long
  lat_range = LAT_MAX - LAT_MIN
  long_range = LONG_MAX - LONG_MIN

  lat = LAT_MIN + (lat_range * rand)
  long = LONG_MIN + (long_range * rand)
  [lat, long]
end

def hub_attributes
    lat_long = generate_random_lat_long
  {
    name: Faker::Name.name,
    location_id: HubLocationID.next,
    latitude: lat_long[0],
    longitude: lat_long[1],
    status_code: [-1,0,1].sample
  }
end

def generate_datetime_from_last_year
  rand(1.year).seconds.ago
end

#For development purposes so team can easily login
Admin.create!(
  name: "susteq",
  email: "susteq@dbc.com",
  password: "asdf;lkj"
)

Provider.create!(
  name: "ABC Water Service Provider",
  address: "Nairobi",
  country: "Kenya",
  duns_number: "121312312"
).employees.create!(
  name: "John Doe",
  email: "susteq_employee@dbc.com",
  password: "asdf;lkj"
)

5.times do
  Admin.create!(
    name: Faker::Name.name,
    email: Faker::Internet.email,
    password: "asdf;lkj"
  )
end

3.times do
  Provider.create!(
    name: Faker::Company.name,
    address: Faker::Address.street_address,
    country: Faker::Address.country,
    duns_number: rand(100000000..999999999).to_s
  )
end

hub_location_id = 1
Provider.all.each do |provider|
  4.times do
    provider.employees.create!(
      name: Faker::Name.name,
      email: Faker::Internet.email,
      password: "asdf;lkj"
    )
  end


  rand(1..3).times do
    pump = provider.pumps.create!(hub_attributes)
    5.times do
      pump.transactions.create!(
        transaction_time: generate_datetime_from_last_year,
        transaction_code: 1,
        location_id: hub_location_id,
        amount: rand(1..15)
      )
    end
    hub_location_id += 1
  end

  rand(1..3).times do
    kiosk = provider.kiosks.create!(hub_attributes)
    5.times do
      kiosk.transactions.create!(
        transaction_time: generate_datetime_from_last_year,
        transaction_code: 22,
        location_id: hub_location_id,
        amount: rand(8..20) * 10
      )
    end
    hub_location_id += 1
  end
end

200.times do
  transaction_code = [1, 20, 21, 22, 23, 39, 41].sample
  location_id = (1..10).to_a.sample

  if transaction_code == 39 # if transaction is a sale
    Transaction.create!(
      transaction_time: generate_datetime_from_last_year,
      transaction_code: transaction_code,
      location_id: location_id,
      amount: [109, 111, 132, 133].sample,
      starting_credits: (0..20).to_a.sample,
      ending_credits: (0..20).to_a.sample
    )
  else
    Transaction.create!(
      transaction_time: generate_datetime_from_last_year,
      transaction_code: transaction_code,
      location_id: location_id,
      amount: (50..200).to_a.sample
    )
  end
end
