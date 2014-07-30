require 'rspec'
require_relative '../lib/impatient_watchdog'

class Minutes
  def self.ago(n)
    Time.now - (n * 60)
  end
end

describe ImpatientWatchdog do

  let(:simple_config) do
    {
      'mood_cutoffs_in_hours' =>
      {
        'enraged' => 3,
        'angry' => 2,
        'neutral' => 1
      }
    }
  end

  let(:osito) { ImpatientWatchdog.new(simple_config) }

  it "should be happy when below neutral cutoff" do
    expect(osito.mood(:waiting_since => Minutes.ago(59))).to eq 'happy'
  end

  it "should be neutral below angry cutoff" do
    expect(osito.mood(:waiting_since => Minutes.ago(119))).to eq 'neutral'
  end

  it "should be angry below enraged cutoff" do
    expect(osito.mood(:waiting_since => Minutes.ago(179))).to eq 'angry'
  end

  it "should be enraged when above cutoff" do
    expect(osito.mood(:waiting_since => Minutes.ago(181))).to eq 'enraged'
  end


  private

  def minutes_ago
    Time.now - (n * 60)
  end

end
