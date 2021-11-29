require 'sqlite3'
require 'colorized_string'

class StudyItem
  attr_accessor :title, :category, :description, :done

  def initialize(title:, category: "Ruby", description:, done: 0)
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
    category = gets.to_i
    category == 1 ? @category = "Ruby" : @category = "Javascript"
  end

  def self.all
    db = SQLite3::Database.open "db/database.db"
    db.results_as_hash = true
    topics = db.execute "SELECT title, description, category, done FROM topics"
    db.close
    topics.map { |topic| new(title: topic["title"], description: topic["description"], category: topic["category"], done: topic["done"]) }
  end

  def save_to_db
    db = SQLite3::Database.open "db/database.db"
    db.execute "INSERT INTO topics VALUES('#{title}', '#{description}', '#{category}', '#{done}')"
    db.close
    self
  end

  def self.register
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
  
    current_item.save_to_db
  
    print "\033[07C"
    puts ColorizedString["
      Item de estudo #{current_item.title} criado na categoria #{current_item.category}."].colorize(:magenta)
  end

  def self.delete_from_db(title)
    db = SQLite3::Database.open "db/database.db"
    db.execute "DELETE FROM topics WHERE title = '#{title}'"
    db.close
  end

  def update_item(column, new_item, title)
    db = SQLite3::Database.open "db/database.db"
    db.execute "UPDATE topics SET '#{column}' = '#{new_item}' WHERE title = '#{title}'"
    db.close
  end

  def self.find(query, term)
    db = SQLite3::Database.open "db/database.db"
    db.results_as_hash = true
    topics = db.execute "SELECT title, description, category, done FROM topics where #{query} '#{term}'"
    db.close
    topics.map { |topic| new(title: topic["title"], description: topic["description"], category: topic["category"], done: topic["done"]) }
  end
end