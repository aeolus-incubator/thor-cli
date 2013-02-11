RSpec::Matchers.define :include_all do |*expected|
  match do |actual|
    @missing = []
    [ expected ].flatten.each do |expected_one|
      @missing << expected_one unless actual.include? expected_one
    end
    @missing.empty?
  end

  failure_message_for_should do |actual|
    "expected that '#{actual}' would include all of #{nice_join(expected)}\n it misses #{nice_join(@missing)}"
  end

  failure_message_for_should_not do |actual|
    "expected that '#{actual}' would not include all of #{nice_join(expected)}\n it misses #{nice_join(@missing)}"
  end

  description do
    "include all of #{nice_join(expected)}"
  end

  def nice_join(words, common_sep = ', ', last_sep = ' and ', quotes = "\"")
    unless words.empty?
      quoted_words = words.map{|word| quotes + word + quotes}
      quoted_words[0..-2].join(common_sep) + last_sep + quoted_words.last
    end
  end
end

RSpec::Matchers.define :exclude_all do |*expected|
  match do |actual|
    @redundant = []
    [ expected ].flatten.each do |expected_one|
      @redundant << expected_one if actual.include? expected_one
    end
    @redundant.empty?
  end

  failure_message_for_should do |actual|
    "expected that '#{actual}' would exclude all of #{nice_join(expected)}\n it contains #{nice_join(@redundant)}"
  end

  failure_message_for_should_not do |actual|
    "expected that '#{actual}' would not exclude all of #{nice_join(expected)}\n it contains #{nice_join(@redundant)}"
  end

  description do
    "exclude all of #{nice_join(expected)}"
  end

  def nice_join(words, common_sep = ', ', last_sep = ' and ', quotes = "\"")
    unless words.empty?
      quoted_words = words.map{|word| quotes + word + quotes}
      quoted_words[0..-2].join(common_sep) + last_sep + quoted_words.last
    end
  end
end
