require 'lib'


describe Effect do

  context '#apply' do
    let (:result) { Effect.new(nil, operator, operand, nil, property).apply(phase) }
    let (:phase) { Phase.new 10, 5, 50, 0.4 }
    let (:accuracy) { 15 }

    context 'revenue' do
      let (:property)  { 'revenue' }
      let (:subject)   { result.cash.round(accuracy) }

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
      let (:subject)   { result.cost.round(accuracy) }

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


    context 'prob' do
      let (:property)  { 'prob' }
      let (:subject)   { result.prob.round(accuracy) }

      context 'addition' do
        let (:operator)  { :+ }
        let (:operand)   { 0.4 }
        it { is_expected.to eq 0.8 }
      end

      context 'subtraction' do
        let (:operator)  { :- }
        let (:operand)   { 0.35 }
        it { is_expected.to eq 0.05 }
      end

      context 'multiplication' do
        let (:operator)  { :* }
        let (:operand)   { 0.5 }
        it { is_expected.to eq 0.2 }
      end

      context 'division' do
        let (:operator)  { :/ }
        let (:operand)   { 4 }
        it { is_expected.to eq 0.1 }
      end
    end


    context 'risk' do
      let (:property)  { 'risk' }
      let (:subject)   { result.prob.round(accuracy) }

      context 'addition' do
        let (:operator)  { :+ }
        let (:operand)   { 0.3 }
        it { is_expected.to eq 0.1 }
      end

      context 'subtraction' do
        let (:operator)  { :- }
        let (:operand)   { 0.35 }
        it { is_expected.to eq 0.75 }
      end

      context 'multiplication' do
        let (:operator)  { :* }
        let (:operand)   { 0.5 }
        it { is_expected.to eq 0.7 }
      end

      context 'division' do
        let (:operator)  { :/ }
        let (:operand)   { 4 }
        it { is_expected.to eq 0.85 }
      end
    end

  end
end

