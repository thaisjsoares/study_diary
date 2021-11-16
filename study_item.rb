class StudyItem
  attr_accessor :title, :category, :description, :done

  def initialize(title:, category: "Ruby", description:, done: "( )")
    @title = title
    @category = category
    @description = description
    @done = done
  end

  def choose_category
    puts ColorizedString["
      [1] Ruby
      [2] Javascript"].colorize(:magenta)
 
    puts ColorizedString["
      Escolha uma categoria para seu item de estudo:"].colorize(:magenta)

    print "\033[1A\033[53C"
    category = gets.chomp.to_i

    category == 1 ? @category = "Ruby" : @category = "Javascript"
  end

end