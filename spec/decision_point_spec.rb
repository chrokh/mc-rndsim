require 'lib'


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


  context '#epvs' do
    xit 'works'
  end


  context '#enpv' do
    xit 'works'
  end


end

