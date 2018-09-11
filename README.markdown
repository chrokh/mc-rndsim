# Monte Carlo Simulation of Policy Intervention for R&D

This simple Monte Carlo simulation explores the effects of phase and agent parameter changes (which proxy policy intervention changes) on (1) the ENPV of R&D projects, and (2) the results of ENPV-based go/no-go decisions on said R&D projects.

Agent parameters are:

- Discount rate
- Threshold (i.e. minimum ENPV required for a go-decision)

Phase parameters are:

- Time (i.e. phase duration expressed in years)
- Cost
- Revenue
- Probability of success

We are specifically employing this Monte Carlo simulation to explore the effects of different policy interventions on antibiotics R&D.


# Usage

`ruby main.rb [n] [params.yaml] [phases.csv] [output.csv] [seed]`

- `n` The number of samples/worlds/runs to generate and explore.
- `params.yaml` Path to YAML file containing stochastic simulation parameters.
- `phases.csv` Path to CSV file containing list of stochastic phases.
- `output.csv` Path to output CSV file (which will be overwritten without prompting!).
- `seed` (optional) An integer to seed the randomizer.


# Examples

TODO


# License

The MIT License (MIT).

Copyright 2018-20XX Christopher Okhravi

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
