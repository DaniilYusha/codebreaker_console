# frozen_string_literal: true

class Decorator
  EXACT_MATCH = '+'
  INEXACT_MATCH = '-'

  def result_beautify(checked_code)
    puts EXACT_MATCH * checked_code.dig(:exact_matches) + INEXACT_MATCH * checked_code.dig(:inexact_matches)
  end

  def stats_beautify(statistics)
    statistics.each do |user|
      user.transform_keys! { |k| k.to_s.capitalize.gsub(/_/, ' ').insert(-1, ':') }
    end
  end
end
