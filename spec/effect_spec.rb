require 'lib'


describe Effect do

  context '#apply' do
    let (:result) { Effect.new(operator, operand, nil, property).apply(phase) }
    let (:phase) { Phase.new 10, 5, 50, 0.5 }


    context 'revenue' do
      let (:property)  { 'revenue' }
      let (:subject)   { result.cash }

      context 'addition' do
        let (:operator)  { :+ }
        let (:operand)   { 100 }
        it { is_expected.to eq 150 }
      end

      context 'subtraction' do
        let (:operator)  { :- }
        let (:operand)   { 4 }
        it { is_expected.to eq 46 }
      end

      context 'multiplication' do
        let (:operator)  { :* }
        let (:operand)   { 2 }
        it { is_expected.to eq 100 }
      end

      context 'division' do
        let (:operator)  { :/ }
        let (:operand)   { 4 }
        it { is_expected.to eq 12.5 }
      end
    end


    context 'cost' do
      let (:property)  { 'cost' }
      let (:subject)   { result.cost }

      context 'addition' do
        let (:operator)  { :+ }
        let (:operand)   { 5 }
        it { is_expected.to eq 10 }
      end

      context 'subtraction' do
        let (:operator)  { :- }
        let (:operand)   { 4 }
        it { is_expected.to eq 1 }
      end

      context 'subtraction more than cost' do
        let (:operator)  { :- }
        let (:operand)   { 8 }
        it { is_expected.to eq 0 }
      end

      context 'multiplication' do
        let (:operator)  { :* }
        let (:operand)   { 3 }
        it { is_expected.to eq 15 }
      end

      context 'division' do
        let (:operator)  { :/ }
        let (:operand)   { 2 }
        it { is_expected.to eq 2.5 }
      end
    end

  end
end

