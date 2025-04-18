class PokemonSystem
  attr_accessor :loadtransition

  def initialize
    @loadtransition = false
  end

  def to_hash
    hash = {}
    instance_variables.each do |var|
      hash[var.to_s.delete("@")] = instance_variable_get(var)
    end
    return hash
  end
end
