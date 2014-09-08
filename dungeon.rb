class Dungeon
  attr_accessor :player

  def initialize(player_name)
    @ghost = Player.new("Ghost1")
    @player = Player.new(player_name)
    @rooms = []
    @ghost_rooms = []
  end

  #adding rooms
  def add_room(reference, name, description, connections)
    @rooms << Room.new(reference, name, description, connections)
  end

  def die_cliff
    puts "You fell off a cliff and died!  Sorry!"
    exit
  end

  def die_ghost
    puts "Oh no! A ghost found you, and you died of fright!"
    exit
  end

  def win
    puts "You found the exit and avoided all the ghosts!  Congratulations, you win!"
    exit
  end


  def setup_rooms
    add_room(:dining, "Dining Room", "a spacious dining room with place settings on the table", {:e => :cliff, :w => :jail, :s => :cliff, :n => :cliff})
    add_room(:jail, "Jail Cell", "a small, musty, jail cell", {:e => :dining, :w => :kitchen, :s => :cliff, :n => :largecave})
    add_room(:largecave, "Large Cave", "a large cavernous cave", {:e => :cliff, :w => :smallcave, :s => :jail, :n => :cliff})
    add_room(:smallcave, "Small Cave", "a small, claustrophobic cave", {:e => :largecave, :w => :cliff, :s => :kitchen, :n => :escape})
    add_room(:kitchen, "Kitchen", "a messy kitchen with food strewn about", {:e => :jail, :w => :cliff, :s => :cliff, :n => :smallcave})
    add_room(:cliff, "Cliff", "You fall off a cliff!", {})
    add_room(:escape, "Outside", "an open field", {:south => :smallcave})
  end


  def play
    setup_rooms
    puts """
Oh no!  You've upset the queen--again--and have been thrown into jail...again!
Luckily, you know your way around these dungeon rooms pretty well.  Try to get
to the outdoors by choosing east, west, north or south.  But watch out!
Some of the doors might not go where you'd like.  Oh, and watch out for ghosts! \n
To start your escape, please press <enter>.
If you'd like to exit please type \"abort\""
    input = gets.chomp
    if input == "abort"
      exit
    else
      puts "First off, what is your name?"
      print "> "
      name = gets.chomp
      if name == "abort"
        exit
      end
      @player.name = name
      puts
      puts "Great, #{@player.name}!  Let's get started!"
      puts
    end
    @player.location = :jail
    next_room

  end

  def next_room()

    direction = nil
    while direction != "abort"

      if @player.location == :cliff
        die_cliff
      elsif @player.location == @ghost.location
        die_ghost
      elsif @player.location == :escape
        win
      end

      show_current_description

      puts "Which direction would you like to go, #{@player.name}? <north, south, east, or west>"
      print "> "
      direction = gets.chomp
      if direction == "abort"
        exit
      end
      direction = direction.chr.to_sym

      if find_room_in_direction(direction)
        @ghost.location = @rooms[rand(0..@rooms.count-3)].reference
        go(direction)
      else
        puts
        puts "Sorry, that's not a valid direction, try again please!"
      end
    end
    exit

  end


  #calls find_room_in_dungeon method using the player's current location,
  # which is an instance of a Room object, then prints the description
  def show_current_description
    if @player.location != :cliff
      puts find_room_in_dungeon(@player.location).full_description
    end
  end

  #looks through the rooms array, until it finds the room that has the
  # reference that was passed in
  def find_room_in_dungeon(reference)
    @rooms.detect {|room| room.reference == reference }
  end

  # calls the find_room_in_dungeon method using the player's current location,
  # then finds the room in the direction specified, using the hash that was
  # created when the room was added
  def find_room_in_direction(direction)
    find_room_in_dungeon(@player.location).connections[direction]
  end

  # prints where the player decides to go, sets the current player location to
  # the room in the direction passed into the method, then calls show_current_description
  # with the updated player location
  def go(direction)
    puts "\nYou go " + direction.to_s
    @player.location = find_room_in_direction(direction)
    #@ghost.location = find_room_in_dungeon()
    #show_current_description
  end

  class Player
    attr_accessor :name, :location

    def initialize(name)
      @name = name
    end

    def ghost_roam
      @location = @rooms[rand(0..@rooms.count-3)]
    end


  end


  class Room

    attr_accessor :reference, :name, :description, :connections

    def initialize(reference, name, description, connections)
      @reference = reference
      @name = name
      @description = description
      @connections = connections
    end

    def full_description
      puts "You are in #{@description}."
    end

  end

end

#Create the main dungeon object
my_dungeon = Dungeon.new("Allie")
my_dungeon.play()
