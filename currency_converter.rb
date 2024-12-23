require 'net/http'
require 'json'

# Fetch the exchange rate from the API
def fetch_exchange_rate(base_currency, target_currency)
  url = URI("https://api.exchangerate.host/latest?base=#{base_currency}&symbols=#{target_currency}")
  response = Net::HTTP.get(url)
  data = JSON.parse(response)

  if data['rates'] && data['rates'][target_currency]
    data['rates'][target_currency]
  else
    puts "Error fetching exchange rate. Check your currency codes."
    nil
  end
end

# Convert the amount using the fetched exchange rate
def convert_currency(amount, rate)
  (amount * rate).round(2)
end

# List of popular currencies
def popular_currencies
  %w[USD EUR JPY GBP AUD CAD CHF CNY BRL ARS]
end

# Main program
puts "Welcome to the Currency Converter!"
puts "Supported currencies: #{popular_currencies.join(', ')}"

print "Enter the amount to convert: "
amount = gets.chomp.to_f

print "Enter the base currency (e.g., USD): "
base_currency = gets.chomp.upcase

print "Enter the target currency (e.g., EUR): "
target_currency = gets.chomp.upcase

# Check if the entered currencies are supported
if popular_currencies.include?(base_currency) && popular_currencies.include?(target_currency)
  rate = fetch_exchange_rate(base_currency, target_currency)

  if rate
    converted_amount = convert_currency(amount, rate)
    puts "#{amount} #{base_currency} is equal to #{converted_amount} #{target_currency} at the current rate of #{rate}."
  else
    puts "Conversion failed. Please try again."
  end
else
  puts "One or both of the entered currencies are not supported. Please use the supported currencies."
end
