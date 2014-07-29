require 'rspec'
require_relative '../lib/impatient_watchdog'

describe ImpatientWatchdog do

  let(:simple_config) do
    {
      'mood_cutoffs_in_minutes' =>
      {
        'enraged' => 10,
        'angry' => 5,
        'neutral' => 1
      }
    }
  end

  let(:osito) { ImpatientWatchdog.new(simple_config) }

  it "should be happy when below neutral cutoff" do

  end

  it "should be neutral below angry cutoff" do
    expect(osito.mood(:waiting_since => (Time.now - 120))).to eq 'neutral'
  end

  it "should be angry below enraged cutoff" do
    expect(osito.mood(:waiting_since => (Time.now - 330))).to eq 'angry'
  end

  it "should be enraged when above cutoff" do
    expect(osito.mood(:waiting_since => (Time.now - 601))).to eq 'enraged'
  end


end
