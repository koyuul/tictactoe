class String
  def is_integer?
    self.to_i.to_s == self
  end
end

ALPHABET = "abcdefghijklmnopqrstuvwxyz".split('')
class GameBoard

  attr_accessor :hash_values
  attr_reader :last_number, :last_letter, :print_letters, :print_numbers

  def initialize(side_length)
    until side_length<=26
      p "board length too long. please enter value under 27"
      side_length = gets.chomp.to_i
    end
    @side_length = side_length #how long the board will be
    @hash_values = {} #hash that stores the values for the game
    @current_player = "player2"

    @last_letter = ALPHABET[@side_length-1] #-1 because array starts at 0
    @last_number = @side_length
    (ALPHABET[0]..ALPHABET[@side_length-1]).each do |current_letter|
      @last_number.times do |current_number|
        @hash_values["#{current_letter}#{current_number+1}"] = "☐"
      end
    end
  end

  def print_grid
    numbers_array = (1..@last_number).to_a
    @print_numbers = ""
    numbers_array.each do |value| #values <9 and >9 are spaced differently
      if value<=9 then @print_numbers += " #{value} |"
      elsif value >9 then @print_numbers += "#{value} |"
      end
    end
    puts " " + print_numbers

    display_hash = @hash_values.values
    display_hash.each_slice(@side_length).with_index do |line, i| #splits grid into appropriate measurements
      @print_letters = (ALPHABET[0]..ALPHABET[@side_length-1]).to_a
      puts @print_letters[i] + " " + line.join(" | ") + " | \n" #extra stuff is for aligning grid lines
      puts "-" + "---+"*numbers_array.length
    end
  end

  def user_input
    p "Player 1: You are X. Player 2: You are O"
    p "#{@current_player}: Please enter the spot you want to place your mark on in the format 'A1'."
    divided_placements = gets.chomp.split('').group_by{|value| value.is_integer?}
    placements=[]
    divided_placements.values.each{|array| placements.push(array.join(''))}
    letter_input = placements[0]
    number_input = placements[1]
    check_letter = letter_input.nil? ? false : @print_letters.include?(letter_input.downcase)
    check_number = number_input.nil? ? false : @print_numbers.include?(number_input)
    #confirm its in right format
    until check_letter && check_number do
      puts "'#{placements.join('')}' is in invalid. Please enter it in LetterNumber format (eg: A1, B3):"
      divided_placements = gets.chomp.split('').group_by{|value| value.is_integer?}
      placements=[]
      divided_placements.values.each{|array| placements.push(array.join(''))}

      if placements.length==2 then
        letter_input = placements[0]
        number_input = placements[1]
        check_letter = letter_input.nil? ? false : @print_letters.include?(letter_input.downcase)
        check_number = number_input.nil? ? false : @print_numbers.include?(number_input)
      else next
      end

    end
    #update display_hash
    player_symbol = (@current_player == "player1") ? "X" : "O"
    @hash_values["#{letter_input}#{number_input}"] = player_symbol
    #switch players

  end

  def check_win

    #horizontal wins
    @hash_values.each_slice(@last_number).with_index do |h_line, current_line|
      symbols_in_a_row = 1
      h_line.each_with_index do |pair, inline_index|
        key = pair[0]
        value = pair[1]
        next_value = h_line[inline_index+1][1] unless inline_index+1 > h_line.length-1
        unless value == "☐"
          if next_value == value then
            symbols_in_a_row+=1
            else next
          end
        end
      end
      if symbols_in_a_row == 3 then
        print_grid
        p "#{@current_player} wins horizontally!"
        symbols_in_a_row = 0
        return true
      end
    end

    #vert wins
    #create hash sorted by number
    v_arranged =  hash_values.to_a.sort_by{|pairs| pairs[0][1]}
    v_arranged.each_slice(ALPHABET.index(@last_letter)+1).with_index do |v_line, current_line|
      symbols_in_a_row = 1
      v_line.each_with_index do |pair, inline_index|
        key = pair[0]
        value = pair[1]
        next_value = v_line[inline_index+1][1] unless inline_index+1 > v_line.length-1
        unless value == "☐"
          if next_value == value then
            symbols_in_a_row+=1
            else next
          end
        end
      end

      if symbols_in_a_row == 3 then
        print_grid
        p "#{@current_player} wins vertically!"
        return true
        symbols_in_a_row = 0
      end
    end

    #diagonal wins
    d_arranged = []
    line_limit = @side_length
    (@side_length-2).times.with_index do |offset| #add upper diag lines
      d_line_upper = []
      d_line_lower = []
      line_limit.times.with_index do |i|
        d_line_upper.push("#{ALPHABET[i+offset]}#{i+1}")
        d_line_lower.push("#{ALPHABET[i]}#{i+1+offset}")
      end
      line_limit-=1
      d_arranged.push(d_line_upper)
      d_arranged.push(d_line_lower)
    end

    d_arranged.each_with_index do |d_line, i|
      symbols_in_a_row = 1
      d_line.each_with_index do |key, inline_index|
        value = @hash_values["#{key}"]
        next_value = @hash_values["#{d_line[inline_index+1]}"] unless inline_index+1 > d_line.length-1
        unless value == "☐"
          if next_value == value then
            symbols_in_a_row+=1
            else next
          end
        end
      end

      if symbols_in_a_row == 3 then

        p "#{@current_player} wins diagonally!"
        return true
        symbols_in_a_row = 0
      end

    end
    @current_player = (@current_player == "player1") ? "player2" : "player1"
  end

  def play_game
    until check_win==true do
        print_grid
        user_input
    end
  end
end

p "please enter the length of the board you would like (eg: 3x3 would be 3)"
length = gets.chomp.to_i
until length.is_i? do
  until length >
  p "please enter an integer"
  length = gets.chomp.to_i
end
game_board = GameBoard.new(length)
game_board.play_game
