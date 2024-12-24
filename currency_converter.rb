require 'net/http'
require 'json'

# Fetch the exchange rate and converted amount from the API
def fetch_conversion(base_currency, target_currency, amount)
  access_key = "72a00190df5d1e4a33eedfd60a56d89c" # Tu clave API
  url = URI("https://api.exchangerate.host/convert?access_key=#{access_key}&from=#{base_currency}&to=#{target_currency}&amount=#{amount}")
  begin
    response = Net::HTTP.get(url)
    data = JSON.parse(response)

    if data['success'] == true && data['result']
      { rate: data['info']['rate'], converted_amount: data['result'] }
    else
      puts "Error: API returned unexpected response. Check currency codes or try again later."
      puts "API Response: #{data}" # Para depuración
      nil
    end
  rescue JSON::ParserError
    puts "Error parsing API response. Ensure the API returns valid JSON."
    nil
  rescue StandardError => e
    puts "Network or other error: #{e.message}"
    nil
  end
end

# List of supported currencies
def supported_currencies
  %w[USD EUR JPY GBP AUD CAD CHF CNY BRL ARS]
end

# Main program
puts "Welcome to the Currency Converter!"
puts "Supported currencies: #{supported_currencies.join(', ')}"

print "Enter the amount to convert: "
amount = gets.chomp.to_f

print "Enter the base currency (e.g., USD): "
base_currency = gets.chomp.upcase

print "Enter the target currency (e.g., EUR): "
target_currency = gets.chomp.upcase

if supported_currencies.include?(base_currency) && supported_currencies.include?(target_currency)
  result = fetch_conversion(base_currency, target_currency, amount)

  if result
    rate = result[:rate]
    converted_amount = result[:converted_amount]
    puts "#{amount} #{base_currency} is equal to #{converted_amount} #{target_currency} at the current rate of #{rate}."
  else
    puts "Conversion failed. Please try again."
  end
else
  puts "One or both of the entered currencies are not supported. Please use the supported currencies."
end

