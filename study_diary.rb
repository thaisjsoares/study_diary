require 'colorized_string'
require_relative 'study_options'
require_relative 'study_item'

$all_items = {}

if !(File.zero?("diary.txt"))
  f = File.open("diary.txt")
  f.each_line { |line| 
    line.delete! "/[]/"
    line.delete! "/\"/"
    back_to_array = line.split(", ")
    $all_items[f.lineno - 1] = [back_to_array[0], back_to_array[1], back_to_array[2], back_to_array[3].chomp]
  }
  f.close
end

puts `clear`

print "\033[6C"
puts ColorizedString["Bem-vinde ao Diário de Estudos"].black.on_cyan
option = 0

while option != 6
  option = display

  case option 
  when 1
    puts `clear`
    show
  when 2
    puts `clear`
    edit
  when 3
    puts `clear`
    list_by_category
  when 4
    puts `clear`
    list_by_done
  when 5
    puts `clear`
    search
  end
end

save
puts ""
print "\033[6C"
puts ColorizedString["Obrigada por utilizar o Diário de Estudos"].black.on_cyan
puts ""
