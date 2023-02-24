

class Dog
    attr_accessor :name, :breed, :id
    def initialize(name:, breed:,  id: nil)
       @name = name
       @breed = breed
       @id = id
   end
   #  CREATE TABLE
   
   def self.create_table
       sql = <<-SQL
         CREATE TABLE IF NOT EXISTS dogs(id INTEGER PRIMARY KEY, name TEXT, breed TEXT)
       SQL
       DB[:conn].execute(sql)
     end
      ##.DROP TABLE
      def self.drop_table
       sql = <<-SQL
         DROP TABLE IF EXISTS dogs
       SQL
   
       DB[:conn].execute(sql)
     end
     def save
       sql = <<-SQL
         INSERT INTO dogs(name, breed) VALUES(?, ?)
       SQL
       #insert the dog
       DB[:conn].execute(sql, self.name, self.breed)
   
       #get the dogs ID from the database and save it to the Ruby Instance
       self.id = DB[:conn].execute("SELECT last_insert_rowid()FROM dogs")[0][0]
   
       #return the Ruby Instance
       self
     end
     ##.CREATE NEW DOG OBJECT
     def self.create(name:, breed:)
       dog = Dog.new(name: name, breed: breed)
       dog.save
     end
     ##.NEW_FROM_DB
     def self.new_from_db(row)
       self.new(id: row[0], name: row[1], breed: row[2])
     end
   
     ##.ALL
     def self.all
       sql = <<-SQL
         SELECT * FROM dogs
       SQL
       DB[:conn].execute(sql).map do |row|
         self.new_from_db(row)
       end
     end
   ##.FIND_BY_NAME
   def self.find_by_name(name)
       sql = <<-SQL
         SELECT * FROM dogs WHERE name = ? LIMIT 1
       SQL
       DB[:conn].execute(sql, name).map do |row|
         self.new_from_db(row)
       end.first #(chaining--grabs first element from the returned array)
     end
   
     ##.FIND
     def self.find(id)
       sql = <<-SQL
         SELECT * FROM dogs WHERE id = ? LIMIT 1
       SQL
       DB[:conn].execute(sql, id).map do |row|
           self.new_from_db(row)
       end.first
   end
   
   end
