require 'colorized_string'
require_relative 'study_item'

def clear
  system("clear")
end

def welcome_bye(message)
  print "\033[6C"
  puts ColorizedString[message].black.on_cyan
end

def display
  puts ColorizedString["
    ┌──────────────────────────────────────┐
    │ [1] Ver tópicos cadastrados          │
    │ [2] Editar diário                    │
    │ [3] Listar por categoria             │
    │ [4] Listar por tópicos concluídos    │
    │ [5] Buscar                           │
    │ [6] Sair                             │
    └──────────────────────────────────────┘
                        
      Escolha uma opção:                  "].colorize(:cyan)

  print "\033[1A\033[25C"
  option = gets.to_i
end

def show
  puts ColorizedString["
      Itens cadastrados:"].colorize(:light_red)
  puts ""

  topics = StudyItem.all
  
  topics.each.with_index(1) do |topic, i| 
    print "\033[6C"
    checked = topic.done == 0 ? "( )" : "(X)"
    puts ColorizedString["[#{i}] #{topic.title} (#{topic.category}) #{checked}"].colorize(:light_red)
  end
end

def erase
  show

  puts ColorizedString["
      Escolha uma entrada para deletar:"].colorize(:magenta)

  print "\033[1A\033[40C"
  option = gets.to_i

  topics = StudyItem.all

  title = topics[option - 1].title
  StudyItem.delete_item(title)

  puts ColorizedString["
      Item deletado."].colorize(:magenta)
end

def change
  show

  puts ColorizedString["
      Escolha a entrada para editar:"].colorize(:magenta)

  print "\033[1A\033[37C"
  item_to_edit = gets.to_i

  puts ColorizedString["
      [1] Editar título
      [2] Editar descrição
      [3] Editar categoria"].colorize(:magenta)
 
  puts ColorizedString["
      Escolha uma opção:"].colorize(:magenta)

  print "\033[1A\033[25C"
  what_to_edit = gets.to_i

  topics = StudyItem.all
  title = topics[item_to_edit - 1].title

  case what_to_edit
  when 1
    puts ColorizedString["
      Novo título:"].colorize(:magenta)
    print "\033[1A\033[19C"
    column = "title"
  when 2
    puts ColorizedString["
      Nova descrição:"].colorize(:magenta)
    print "\033[1A\033[22C"
    column = "description"
  when 3
    puts ColorizedString["
      Nova categoria:"].colorize(:magenta)
    print "\033[1A\034[21C"
    column = "category"
  end

  new_item = gets.chomp

  topics[item_to_edit - 1].update_item(column, new_item, title)

  puts ColorizedString["
      Item editado."].colorize(:magenta)
end

def mark_as_done
  show

  puts ColorizedString["
      Escolha a entrada para marcar como concluída:"].colorize(:magenta)

  print "\033[1A\033[52C"
  option = gets.to_i

  topics = StudyItem.all
  column = "done"
  new_item = "1"
  title = topics[option - 1].title
  topics[option - 1].update_item(column, new_item, title)

  puts ColorizedString["
      Item marcado como concluído."].colorize(:magenta) 
end

def edit
  puts ColorizedString["
      [1] Cadastrar
      [2] Deletar
      [3] Editar
      [4] Marcar como concluído"].colorize(:magenta)
 
    puts ColorizedString["
      Escolha uma opção:"].colorize(:magenta)

    print "\033[1A\033[25C"
    option = gets.to_i

    case option
    when 1
      StudyItem.register
    when 2
      erase
    when 3 
      change
    when 4
      mark_as_done
    end
end

def list_by_category
  puts ColorizedString["
      [1] Ruby
      [2] Javascript"].colorize(:light_magenta)
 
  puts ColorizedString["
      Escolha uma categoria:"].colorize(:light_magenta)

  print "\033[1A\033[29C"
  category = gets.to_i == 1 ? "Ruby" : "Javascript"
  puts ""

  topics = StudyItem.find_by_category(category)
  topics.each.with_index do |topic, i| 
    print "\033[6C"
    checked = topic.done == 0 ? "( )" : "(X)"
    puts ColorizedString["[#{i}] #{topic.title} (#{topic.category}) #{checked}"].colorize(:light_red)
  end
end

def list_by_done
  topics = StudyItem.find_by_done
  topics.each.with_index do |topic, i| 
    print "\033[6C"
    puts ColorizedString["[#{i}] #{topic.title} (#{topic.category}) (X)"].colorize(:light_red)
  end
end

def search
  puts ColorizedString["
      Digite o termo para a busca:"].colorize(:yellow)
  print "\033[1A\033[35C"
  search_for = gets.chomp

  puts ColorizedString["
      Resultado da busca:"].colorize(:yellow)
  puts ""

  topics = StudyItem.find(search_for)

  if topics.length != 0
    topics.each.with_index do |topic, i| 
      checked = topic.done == 0 ? "( )" : "(X)"
      print "\033[6C"
      puts ColorizedString["[#{i}] #{topic.title} (#{topic.category}) #{checked}"].colorize(:light_red)
    end
  else
    print "\033[6C"
    puts ColorizedString["Sem resultados"].colorize(:yellow)
  end
end

clear

welcome_bye("Bem-vinde ao Diário de Estudos")

option = 0

while option != 6
  option = display

  clear

  case option 
  when 1
    show
  when 2
    edit
  when 3
    list_by_category
  when 4
    list_by_done
  when 5
    search
  end
end

puts ""
welcome_bye("Obrigada por utilizar o Diário de Estudos")
puts ""
