


class ABTest


  begin
    a = 50.0
    # Returns array of [z-score, percentage]
    norm_dist = []
    (0.0..3.1).step(0.01) { |x| norm_dist << [x, a += 1 / Math.sqrt(2 * Math::PI) * Math::E ** (-x ** 2 / 2)] }
    # We're really only interested in 90%, 95%, 99% and 99.9%.
    Z_TO_PROBABILITY = [90, 95, 99, 99.9].map { |pct| [norm_dist.find { |x,a| a >= pct }.first, pct] }.reverse
  end

  def self.probability(score)
    score = score.abs
    probability = AbTest::Z_TO_PROBABILITY.find { |z,p| score >= z }
    probability ? probability.last : 0
  end

end