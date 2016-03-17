path = File.join(File.expand_path(File.dirname(__FILE__)), 'food_truck_parser')
Dir["#{path}/*.rb"].each { |f| require f }
Dir["#{path}/**/*.rb"].each { |f| require f }
