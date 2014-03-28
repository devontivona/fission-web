


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
    probability = ABTest::Z_TO_PROBABILITY.find { |z,p| score >= z }
    probability ? probability.last : 0
  end

  # # Alternative chosen when this experiment completed.
  # def outcome
  #   return unless @playground.collecting?
  #   outcome = connection.ab_get_outcome(@id)
  #   outcome && _alternatives[outcome]
  # end

  def self.score(alternatives, outcome = nil, probability = 90)
    puts probability
    alts = alternatives
    # sort by conversion rate to find second best and 2nd best
    sorted = alts.sort_by(&:measure)
    base = sorted[-2]
    # calculate z-score
    pc = base.measure
    nc = base.participants
    alts.each do |alt|
      p = alt.measure
      n = alt.participants
      alt.z_score = (p - pc) / ((p * (1-p)/n) + (pc * (1-pc)/nc)).abs ** 0.5
      alt.probability = ABTest.probability(alt.z_score)
    end
    # difference is measured from least performant
    if least = sorted.find { |alt| alt.measure > 0 }
      alts.each do |alt|
        if alt.measure > least.measure
          alt.difference = (alt.measure - least.measure) / least.measure * 100
        end
      end
    end
    # alts.select {|alt| puts "Diff: #{alt.difference}" }
    # best alternative is one with highest conversion rate (best shot).
    # choice alternative can only pick best if we have high probability (>90%).
    best = sorted.last if sorted.last.measure > 0.0
    choice = outcome ? outcome : (best && best.probability >= probability ? best : nil)
    Struct.new(:variations, :best, :base, :worst, :choice, :method).new(alts, best, base, least, choice, :score)
  end

end