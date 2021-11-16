require 'io/console'

def display
  puts ColorizedString["
    ┌──────────────────────────────────────┐
    │ [1] Ver tópicos cadastrados          │
    │ [2] Editar diário                    │
    │ [3] Listar por categoria             │
    │ [4] Listar por tópicos concluídos    │
    │ [5] Buscar                           │
    │ [6] Salvar e sair                    │
    └──────────────────────────────────────┘
                        
      Escolha uma opção:                  "].colorize(:cyan)

  print "\033[1A\033[25C"
  option = gets.chomp.to_i
end

def show
  puts ColorizedString["
      Itens cadastrados:"].colorize(:light_red)
  puts ""

  $all_items.length.times { |i| 
    print "\033[6C"
    puts ColorizedString["[#{i + 1}] #{$all_items[i][0]} (#{$all_items[i][2]}) #{$all_items[i][3]}"].colorize(:light_red)
  }
end

def register
  puts ColorizedString["
      Digite o título do seu tópico de estudo:"].colorize(:magenta)

  print "\033[1A\033[47C"
  title = gets.chomp

  puts ColorizedString["
      Digite uma descrição:"].colorize(:magenta)

  print "\033[1A\033[28C"
  description = gets.chomp

  current_item = StudyItem.new(title: title, description: description)
  current_item.choose_category

  $all_items[$all_items.length] = [current_item.title, current_item.description, current_item.category, current_item.done]

  print "\033[07C"
  puts ColorizedString["
      Item de estudo #{current_item.title} criado na categoria #{current_item.category}."].colorize(:magenta)
end

def erase
  show

  puts ColorizedString["
      Escolha uma entrada para deletar:"].colorize(:magenta)

  print "\033[1A\033[40C"
  option = gets.chomp.to_i

  $all_items.delete(option - 1)
  new_all_times = {}

  $all_items.each_with_index { |pair, i| new_all_times[i] = pair[1] }
  $all_items = new_all_times.clone

  puts ColorizedString["
      Item deletado."].colorize(:magenta)
end

def change
  show

  puts ColorizedString["
      Escolha a entrada para editar:"].colorize(:magenta)

  print "\033[1A\033[37C"
  item_to_edit = gets.chomp.to_i

  puts ColorizedString["
      [1] Editar título
      [2] Editar descrição
      [3] Editar categoria"].colorize(:magenta)
 
  puts ColorizedString["
      Escolha uma opção:"].colorize(:magenta)

  print "\033[1A\033[25C"
  what_to_edit = gets.chomp.to_i

  case what_to_edit
  when 1
    puts ColorizedString["
      Novo título:"].colorize(:magenta)
    print "\033[1A\033[19C"
    new = gets.chomp
    $all_items[item_to_edit - 1][0] = new
  when 2
    puts ColorizedString["
      Nova descrição:"].colorize(:magenta)
    print "\033[1A\033[22C"
    new = gets.chomp
    $all_items[item_to_edit - 1][1] = new
  when 3
    puts ColorizedString["
      Nova categoria:"].colorize(:magenta)
    print "\033[1A\033[21C"
    new = gets.chomp
    $all_items[item_to_edit - 1][2] = new
  end

  puts ColorizedString["
      Item editado."].colorize(:magenta)
end

def mark_as_done
  show

  puts ColorizedString["
      Escolha a entrada para marcar como concluída:"].colorize(:magenta)

  print "\033[1A\033[37C"
  option = gets.chomp.to_i
  $all_items[option - 1][3] = "(X)"
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
    option = gets.chomp.to_i

    case option
    when 1
      register
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
  category = gets.chomp.to_i
  puts ""

  results = []

  $all_items.length.times { |i|
    case category
    when 1
      results << $all_items[i] if $all_items[i][1] == "Ruby"
    when 2
      results << $all_items[i] if $all_items[i][1] == "Javascript"
    end
  }

  results.length.times { |i| 
    print "\033[6C"
    puts ColorizedString["#{results[i][0]} (#{results[i][1]})"].colorize(:light_magenta)
  }
end

def list_by_done
  results = []

  $all_items.length.times { |i|
    results << $all_items[i] if $all_items[i][3] == "(X)"
  }

  results.length.times { |i| 
    print "\033[6C"
    puts ColorizedString["#{results[i][0]} (#{results[i][1]})"].colorize(:light_magenta)
  }
end

def search
  puts ColorizedString["
      Digite o termo para a busca:"].colorize(:yellow)
  print "\033[1A\033[35C"
  search_for = gets.chomp

  puts ColorizedString["
      Resultado da busca:"].colorize(:yellow)
  puts ""

  results = []

  $all_items.length.times { |i|
    if $all_items[i][0].match(/#{search_for}/i) || $all_items[i][1].match(/#{search_for}/i)
      results << $all_items[i]
    end
  }

  if results.length != 0
    results.length.times { |i| 
      print "\033[6C"
      puts ColorizedString["#{results[i][0]} (#{results[i][2]})"].colorize(:yellow)
    }
  else
    print "\033[6C"
    puts ColorizedString["Sem resultados"].colorize(:yellow)
  end
end

def write_to_file
  File.truncate("diary.txt", 0)

  $all_items.length.times { |i| 
    File.write("diary.txt", "#{$all_items[i]}\n", mode: "a")
  } 
end

def save
  puts ""
  print "\033[6C"
  puts ColorizedString["Você gostaria de salvar o diário? [s/n]"].colorize(:yellow)
  print "\033[1A\033[46C"
  yes_or_no = gets.chomp
  write_to_file if yes_or_no == "s" || yes_or_no == "S"
end