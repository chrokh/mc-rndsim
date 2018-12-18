class Helpers
  def self.ladder xs
    xs.reduce([]) { |xs, x| (xs.map{|y| y<<x}) << [x] }
  end
end
