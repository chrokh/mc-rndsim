require_relative '../lib/decision_point'


describe DecisionPoint do
  context '#decision' do
    subject { DecisionPoint.new([], nil, 10) }

    it 'is false if below threshold' do
      allow(subject).to receive(:enpv).and_return(9)
      expect(subject.decision).to eq false
    end

    it 'is true if at threshold' do
      allow(subject).to receive(:enpv).and_return(10)
      expect(subject.decision).to eq true
    end

    it 'is true if above threshold' do
      allow(subject).to receive(:enpv).and_return(11)
      expect(subject.decision).to eq true
    end
  end


  context '#remaining_prob' do
    # Rounded to 8 decimals. TODO: Is this a compounding problem?
    subject { DecisionPoint.new([p1,p2,p3], nil, nil).remaining_prob.round(8) }
    context do
      let (:p1) { double(:prob => 0.5) }
      let (:p2) { double(:prob => 0.4) }
      let (:p3) { double(:prob => 0.3) }
      it { is_expected.to eq 0.06 }
    end
    context do
      let (:p1) { double(:prob => 0.8) }
      let (:p2) { double(:prob => 0.8) }
      let (:p3) { double(:prob => 0.8) }
      it { is_expected.to eq 0.512 }
    end
  end


  # TODO: Should the last probability actually be included?
  context '#cashflows' do
    subject { DecisionPoint.new([p1,p2,p3], nil, nil).cashflows }

    # Mock Cashflow constructor
    before (:each) do
      allow(Cashflow).to receive(:new) do |cash,time,prob0,probN|
        [cash, time, prob0, probN].map{ |x| x.round(6) }
      end
    end

    context do
      let (:p1) { double(time: 2, prob:0.7, cash:10, cost:100) }
      let (:p2) { double(time: 3, prob:0.8, cash:20, cost:200) }
      let (:p3) { double(time: 4, prob:0.9, cash:30, cost:300) }
      it { is_expected.to match_array [
        # $   t   p0       pN
        [-90,   0,  0.504,  0.504],
        [-180,  2,  0.504,  0.72],
        [-270,  5,  0.504,  0.9],
      ] }
    end

    context do
      let (:p1) { double(time: 40, prob:0.55, cash:300, cost:10) }
      let (:p2) { double(time: 30, prob:0.44, cash:200, cost:20) }
      let (:p3) { double(time: 20, prob:0.33, cash:100, cost:30) }
      it { is_expected.to match_array [
        # $   t   p0       pN
        [290, 0,  0.07986, 0.07986],
        [180, 40, 0.07986, 0.1452],
        [70,  70, 0.07986, 0.33]
      ] }
    end
  end


  context '#enpv' do # Full integration
    subject { DecisionPoint.new([p1,p2,p3], rate, nil).enpv.round(accuracy) }
    let (:accuracy) { 12 }

    context 'example 1' do
      let (:p1)   { double(time: 5, prob:0.1, cash:50, cost:100) }
      let (:p2)   { double(time: 6, prob:0.2, cash:60, cost:200) }
      let (:p3)   { double(time: 7, prob:0.3, cash:70, cost:300) }
      let (:rate) { 0.11 }
      it do
        is_expected.to eq (
          (50-100) / (1.11 ** 0)     * ((0.1*0.2*0.3) / (0.1*0.2*0.3)) +
          (60-200) / (1.11 ** 5)     * ((0.1*0.2*0.3) / (0.2*0.3)) +
          (70-300) / (1.11 ** (5+6)) * ((0.1*0.2*0.3) / 0.3)
        ).round(accuracy)
      end
    end

    context 'example 2' do
      let (:p1)   { double(time: 20, prob:0.32, cash:0,    cost:500) }
      let (:p2)   { double(time: 5,  prob:0.87, cash:0,    cost:200) }
      let (:p3)   { double(time: 13, prob:1,    cash:2000, cost:0) }
      let (:rate) { 0.18 }
      it do
        is_expected.to eq (
          (0-500)  / (1.18 ** 0)      * ((0.32*0.87*1) / (0.32*0.87*1)) +
          (0-200)  / (1.18 ** 20)     * ((0.32*0.87*1) / (0.87*1)) +
          (2000-0) / (1.18 ** (20+5)) * ((0.32*0.87*1) / 1)
        ).round(accuracy)
      end
    end
  end

end

