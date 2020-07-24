# frozen_string_literal: true

class Decorator
  EXACT = '+'
  INEXACT = '-'

  def result_beautify(checked_code)
    puts EXACT * checked_code.dig(:exact_matches) + INEXACT * checked_code.dig(:inexact_matches)
  end

  def stats_beautify(statistics)
    statistics.each do |user|
      user.transform_keys! { |k| k.to_s.capitalize.gsub(/_/, ' ').insert(-1, ':') }
    end
  end
end
