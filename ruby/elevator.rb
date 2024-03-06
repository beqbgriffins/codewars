module Elevator
  class Elevator
    attr_reader :current_lvl, :queue, :dir, :pass_inside, :order
    def initialize start_lvl, queue
      @current_lvl = start_lvl
      @queue = Queue.new(queue).sort
      @dir = CheckDirection.call(start_lvl, queue.first[:from])
      @dest = queue.first[:from]
      @pass_inside = []
      @order = []
    end

    def generate_order
      loop do
        next_station
        break if @pass_inside.empty? && @queue.empty?
      end
      @order
    end

    def change_dir
      @dir = @dir == :up ? :down : :up
    end

    def up_next
      return if @queue.empty?

      pass = @queue[@dir].select{|pass| pass.from >= @current_lvl}.min_by{|pass| pass.from}

      return pass if path(@current_lvl, @dest).include?(pass.from)
      nil
    end

    def down_next
      return if @queue.empty?

      pass = @queue[@dir].select{|pass| pass.from <= @current_lvl}.max_by{|pass| pass.from}
      pp"!!!!!!!!!!!"
      pp pass

      return pass if path(@current_lvl, @dest).include?(pass.from)
      nil
    end

    def next_station
      loop do
        pass = send(@dir.to_s + '_next')
        @queue[@dir].delete(pass)
        @pass_inside << pass
        @current_lvl = pass.from
        update_destination
        @order << [pass.from, pass.to]
        @pass_inside.reject!{|pass| pass.to >= }
        pp @order, @pass_inside
        break if @queue[@dir].empty? || @pass_inside.empty?
      end
      change_dir
    end

    def update_destination
      if @dir == :up
        @dest = @pass_inside.max_by{|pass| pass.to}.to
      else
        @dest = @pass_inside.min_by{|pass| pass.to}.to
      end
    end

    def path(a,b)
      if a >= b
        (b..a)
      else
        (a..b)
      end
    end

    def set_order(lvls)
      if @dir == :up
        lvls.sort
      else
        lvls.sort{|x, y| y <=> x}
      end
    end
  end

  class Passenger
    attr_reader :from, :to, :dir
    def initialize from, to
      @from = from
      @to = to
      @dir = CheckDirection.call(from, to)
    end
  end

  class Queue
    def initialize queue
      @queue = queue.map do |pass|
        Passenger.new(pass[:from], pass[:to])
      end
    end

    def sort
      {
        up: @queue.select{|p| p.from < p.to},
        down: @queue.select{|p| p.from > p.to}
      }
    end
  end

  class CheckDirection
    def self.call from, to
      from < to ? :up : :down
    end
  end
end

queue = [
  { from: 3, to: 2 }, # Ал
  { from: 5, to: 2 }, # Бетти
  { from: 2, to: 1 }, # Чарльз
  { from: 2, to: 5 }, # Дэн
  { from: 4, to: 3 }, # Эд
]

people = [
  { from: 3, to: 2 }, # 3rd passenger
  { from: 5, to: 6 }, # 4th passenger
  { from: 2, to: 1 }, # 5th passenger
  { from: 2, to: 5 }, # 1st passenger
  { from: 4, to: 3 }, # 2nd passenger
]

puzzle = [
  {from: 5, to: 4},  # 1st passenger
  {from: 5, to: 3},  # 2nd passenger
  {from: 3, to: 4},  # 3rd passenger
  {from: 0, to: 2},  # 5th passenger
  {from: 3, to: -4}, # 4th passenger
  {from: 1, to: 2}   # 6th passenger
]


pp Elevator::Elevator.new(1, queue).generate_order
pp Elevator::Elevator.new(1, people).generate_order
pp Elevator::Elevator.new(1, puzzle).generate_order