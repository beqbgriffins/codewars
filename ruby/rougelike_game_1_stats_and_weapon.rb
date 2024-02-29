# frozen_string_literal: true

# https://www.codewars.com/kata/651bfcbd409ea1001ef2c3cb/train/ruby
class Character
  class Weapon
    attr_reader :name, :str_multi, :dex_multi, :int_multi, :extra_dmg, :enhanced

    def initialize(name = 'limbs', str_multi = 1, dex_multi = 1, int_multi = 1, extra_dmg = 0, enhanced = false)
      @name = name
      @str_multi = str_multi
      @dex_multi = dex_multi
      @int_multi = int_multi
      @extra_dmg = extra_dmg
      @enhanced = enhanced
    end
  end

  class AddSignToInteger
    def self.call(int)
      int.positive? ?
        "+#{int}" :
        int
    end
  end

  class Humanize
    def self.call(str)
      return str if str == 'limbs'
      str.capitalize.split('_').join(' ')
    end
  end

  module Event
    class FindWeaponEvent
      def message(hero_name:, weapon_name:)
        "#{hero_name} finds '#{weapon_name}'"
      end
    end

    class RandomEvent
      def message(event_name, *args)
        attrs = []
        args = args.flatten
        attrs << "strength #{AddSignToInteger.call(args[0])}" if args[0] != 0
        attrs << "dexterity #{AddSignToInteger.call(args[1])}" if args[1] != 0
        attrs << "intelligence #{AddSignToInteger.call(args[2])}" if args[2] != 0

        "#{event_name}: #{attrs.join(', ')}"
      end
    end
  end

  def initialize(name: 'Hero', strength: 10, dexterity: 10, intelligence: 10, weapon_name: 'limbs')
    @name = name
    @strength = strength
    @dexterity = dexterity
    @intelligence = intelligence
    @weapon = Weapon.new(weapon_name)
    @inventory = [@weapon]
    @event_log = []
  end

  def character_info
    "#{@name}\nstr #{@strength}\ndex #{@dexterity}\nint #{@intelligence}\n#{Humanize.call(@weapon.name.to_s)}#{'(enhanced)' if @weapon.enhanced} #{dmg(@weapon)} dmg"
  end

  def dmg(weapon)
    weapon.str_multi * @strength +
      weapon.dex_multi * @dexterity +
      weapon.int_multi * @intelligence +
      weapon.extra_dmg
  end

  def event_log
    log = ""
    @event_log.each do |event|
      log += "#{event}\n"
    end
    log.chomp
  end

  def enchant_weapon(w1, w2)
    @inventory << Weapon.new(
      w1.name,
      [w1.str_multi, w2.str_multi].max,
      [w1.dex_multi, w2.dex_multi].max,
      [w1.int_multi, w2.int_multi].max,
      [w1.extra_dmg, w2.extra_dmg].max,
      true
    )
    @inventory.delete(w1)
    @inventory.delete(w2)
    check_weapon
  end

  def check_weapon
    @weapon = @inventory.min_by { |w| [- dmg(w), w.name] }
  end

  private def method_missing(name, *args)
    if name.to_s.include?('_of_') && args.length == 4
      args.unshift(name)
      @event_log << Event::FindWeaponEvent.new.message(hero_name: @name, weapon_name: Humanize.call(name.to_s))
      same_weapon = @inventory.find { |w| w.name == name }
      if same_weapon
        enchant_weapon(Weapon.new(*args), same_weapon)
      else
        weapon = Weapon.new(*args)
        @inventory << weapon
        check_weapon
      end
    elsif args.length == 3
      @strength += args[0]
      @dexterity += args[1]
      @intelligence += args[2]
      check_weapon
      @event_log << Event::RandomEvent.new.message(Humanize.call(name.to_s), args)
    else
      super
    end
  end
end

ch = Character.new
puts ch.character_info
pp "!!!!!!!!!"
ch.weapon_of_ninja(1,3,2,10)
puts ch.character_info
ch.weapon_of_ninja(1,3,2,20)
puts ch.character_info