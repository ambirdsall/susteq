require 'faker'

LAT_MIN = -1.377018 # South of Nairobi
LAT_MAX = -1.219302 # North of Nairobi
LONG_MIN = 36.636440 # West of Nairobi
LONG_MAX = 36.959850 # East of Nairobi

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
    location_id: hub_location_id,
    latitude: lat_long[0],
    longitude: lat_long[1],
    status_code: [-1,0,1].sample
  }
end

def generate_date_from_last_six_months
  year = 2014
  month = rand(6)+4
  day = rand(30)+1     #Pour one out for n/31/2014; no pressing reason to add in the logic.
  DateTime.new(year, month, day)
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

hub_location_id = 1

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
        transaction_time: generate_date_from_last_six_months,
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
        transaction_time: generate_date_from_last_six_months,
        transaction_code: 22,
        location_id: hub_location_id,
        amount: rand(8..20) * 10
      )
    end
    hub_location_id += 1
  end
end

# TODO: DRY this repetitive nonsense up.

Transaction.create!(
  transaction_time: generate_date_from_last_six_months,
  transaction_code: 20,
  location_id: 1,
  amount: 2
)
Transaction.create!(
  transaction_time: generate_date_from_last_six_months,
  transaction_code: 20,
  location_id: 1,
  amount: 2
)
Transaction.create!(
  transaction_time: generate_date_from_last_six_months,
  transaction_code: 20,
  location_id: 2,
  amount: 3
)
Transaction.create!(
  transaction_time: generate_date_from_last_six_months,
  transaction_code: 20,
  location_id: 2,
  amount: 4
)

# TC 23

Transaction.create!(
  transaction_time: generate_date_from_last_six_months,
  transaction_code: 23,
  location_id: 2,
  amount: 3,
  starting_credits: 5,
  ending_credits: 10
)
Transaction.create!(
  transaction_time: generate_date_from_last_six_months,
  transaction_code: 23,
  location_id: 2,
  amount: 4,
  starting_credits: 10,
  ending_credits: 5
)
Transaction.create!(
  transaction_time: generate_date_from_last_six_months,
  transaction_code: 23,
  location_id: 100,
  amount: 4,
  starting_credits: 10,
  ending_credits: 5
)
Transaction.create!(
  transaction_time: generate_date_from_last_six_months,
  transaction_code: 23,
  location_id: 1,
  amount: 1,
  starting_credits: 5,
  ending_credits: 10
)
Transaction.create!(
  transaction_time: generate_date_from_last_six_months,
  transaction_code: 23,
  location_id: 1,
  amount: 1,
  starting_credits: 5,
  ending_credits: 10
)
Transaction.create!(
  transaction_time: generate_date_from_last_six_months,
  transaction_code: 23,
  location_id: 2,
  amount: 3,
  starting_credits: 5,
  ending_credits: 10
)
Transaction.create!(
  transaction_time: generate_date_from_last_six_months,
  transaction_code: 23,
  location_id: 2,
  amount: 4,
  starting_credits: 10,
  ending_credits: 5
)
Transaction.create!(
  transaction_time: generate_date_from_last_six_months,
  transaction_code: 23,
  location_id: 1,
  amount: 1,
  starting_credits: 5,
  ending_credits: 10
)
Transaction.create!(
  transaction_time: generate_date_from_last_six_months,
  transaction_code: 23,
  location_id: 2,
  amount: 3,
  starting_credits: 5,
  ending_credits: 10
)
Transaction.create!(
  transaction_time: generate_date_from_last_six_months,
  transaction_code: 23,
  location_id: 2,
  amount: 4,
  starting_credits: 10,
  ending_credits: 5
)
Transaction.create!(
  transaction_time: generate_date_from_last_six_months,
  transaction_code: 23,
  location_id: 1,
  amount: 1,
  starting_credits: 5,
  ending_credits: 10
)
Transaction.create!(
  transaction_time: generate_date_from_last_six_months,
  transaction_code: 23,
  location_id: 2,
  amount: 3,
  starting_credits: 5,
  ending_credits: 10
)
Transaction.create!(
  transaction_time: generate_date_from_last_six_months,
  transaction_code: 23,
  location_id: 2,
  amount: 4,
  starting_credits: 10,
  ending_credits: 5
)

# TC 1

Transaction.create!(
  transaction_time: generate_date_from_last_six_months,
  transaction_code: 1,
  location_id: 2,
  amount: 3
)
Transaction.create!(
  transaction_time: generate_date_from_last_six_months,
  transaction_code: 1,
  location_id: 2,
  amount: 4
)
Transaction.create!(
  transaction_time: generate_date_from_last_six_months,
  transaction_code: 1,
  location_id: 1,
  amount: 2
)
Transaction.create!(
  transaction_time: generate_date_from_last_six_months,
  transaction_code: 1,
  location_id: 1,
  amount: 2
)
Transaction.create!(
  transaction_time: generate_date_from_last_six_months,
  transaction_code: 1,
  location_id: 1,
  amount: 2
)
Transaction.create!(
  transaction_time: generate_date_from_last_six_months,
  transaction_code: 1,
  location_id: 1,
  amount: 2
)
Transaction.create!(
  transaction_time: generate_date_from_last_six_months,
  transaction_code: 1,
  location_id: 2,
  amount: 3
)
Transaction.create!(
  transaction_time: generate_date_from_last_six_months,
  transaction_code: 1,
  location_id: 2,
  amount: 4
)

# TC 41

Transaction.create!(
  transaction_time: Date.new(2014,1,1),
  transaction_code: 41,
  location_id: 1,
  amount: 2
)
Transaction.create!(
  transaction_time: Date.new(2014,2,2),
  transaction_code: 41,
  location_id: 1,
  amount: 2
)
Transaction.create!(
  transaction_time: generate_date_from_last_six_months,
  transaction_code: 41,
  location_id: 2,
  amount: 3
)
Transaction.create!(
  transaction_time: generate_date_from_last_six_months,
  transaction_code: 41,
  location_id: 2,
  amount: 4
)


200.times do
  transaction_code = [1, 20, 21, 22, 23, 39, 41].sample
  location_id = (1..10).to_a.sample

  if transaction_code == 39 # if transaction is a sale
    Transaction.create!(
      transaction_time: generate_date_from_last_six_months,
      transaction_code: transaction_code,
      location_id: location_id,
      amount: [109, 111, 132, 133].sample,
      starting_credits: (0..20).to_a.sample,
      ending_credits: (0..20).to_a.sample
    )
  else
    Transaction.create!(
      transaction_time: generate_date_from_last_six_months,
      transaction_code: transaction_code,
      location_id: location_id,
      amount: (50..200).to_a.sample
    )
  end
end
