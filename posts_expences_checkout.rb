require 'pry'

default_bundles = {:IMG => {10 => 800, 5 => 450},
           :FLAC => {9 => 1147.50, 6 => 810, 3 => 427.50},
           :VID => {9 => 1530, 5 => 900, 3 => 570}
          }

print "Enter Count of Posts with format like(10 IMG 15 FLAC 13 VID):"
input_data = gets.chomp

input_values = input_data.split(/[^\d]/).reject!(&:empty?)
input_keys = input_data.tr("0-9", "").split(" ")
combined_input = Hash[input_keys.zip(input_values)]
output = {:IMG => {}, :FLAC => {}, :VID => {}}

# Calcaute bundles for format with respective to the inputs
combined_input.each do |format|

  default_bundles[format[0].to_sym].keys.each do |key|
    y = false
    x = default_bundles[format[0].to_sym].keys
    x.delete(key)

    x.each do |sub_key|
      if format[1].to_i % key == 0
        output[format[0].to_sym][key] = (format[1].to_i / key)
        y = true
        break
      elsif (format[1].to_i % key) % sub_key == 0
        output[format[0].to_sym][key] = (format[1].to_i / key)
        format[1] = format[1].to_i % key
        break
      end
    end
    break if y
  end
end

#Show output on Terminal
output.each do |frt|
  if frt[1].include?("error")
    puts "#{combined_input[frt[0].to_s]} #{frt[0]}"
    puts frt[1]["error"]
  else
    count = combined_input[frt[0].to_s]
    total_price = 0
    frt[1].keys.each do |frt_key|
      total_price += frt[1][frt_key] * default_bundles[frt[0]][frt_key]
    end
    puts "#{combined_input[frt[0].to_s]} #{frt[0]} $#{total_price}"
    frt[1].each do |bundle|
      puts "     #{bundle[1]} x #{bundle[0]}  $#{bundle[1] * default_bundles[frt[0]][bundle[0]]}"
    end
  end
  puts "---------------------------------------------------"
end
