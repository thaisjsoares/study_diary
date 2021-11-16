require 'colorized_string'
require_relative 'study_options'
require_relative 'study_item'

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

puts ""
print "\033[6C"
puts ColorizedString["Obrigada por utilizar o Diário de Estudos"].black.on_cyan
puts ""
