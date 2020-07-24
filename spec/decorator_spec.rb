# frozen_string_literal: true

RSpec.describe Decorator do
  let(:console) { Console.new }

  describe '#stats_beautify' do
    it 'returns an Array with statistics' do
      expect(subject.stats_beautify(console.statistics.sort_statistics).class).to eq Array
    end
  end
end
