# Monte Carlo Simulation of Policy Intervention for R&D

This simple Monte Carlo simulation explores the effects of phase and agent parameter changes (which proxy policy intervention changes) on (1) the ENPV of R&D projects, and (2) the results of ENPV-based go/no-go decisions on said R&D projects.

Agent parameters are:

- Discount rate
- Threshold (i.e. minimum ENPV required for a go-decision)

Phase (and market) parameters are:

- Time (i.e. phase duration expressed in years)
- Cost
- Revenue
- Probability of success

We are specifically employing this Monte Carlo simulation to explore the effects of different policy interventions on antibiotics R&D.


# Usage

```
ruby main.rb [N] [AGENTS] [PHASES] [INTERVENTIONS] [OUTPUT] [SEED]

N
The number of samples/worlds/runs to generate and explore.

AGENTS
Path to CSV file containing list of stochastic agents.

PHASES
Path to CSV file containing list of stochastic phases.

INTERVENTIONS
Path to CSV file containing list of stochastic interventions.

OUTPUT
Path to output CSV file (which will be overwritten without prompting!).

SEED
(optional) An integer to seed the randomizer.
```



## Agent parameters

Agents must be supplied in CSV format (`AGENTS` above), with headers, as per the spec below. The column order must not be changed. Every world when simulating will only contain a single agent that makes all decisions and the agent will be uniformly selected from the list of agents supplied as input.

The name parameter will be included in the generated output when simulating so that it is easy to tell from which agent distribution the sampled agent stemmed.

```csv
name,    discount_rate,  threshold
STRING,  DIST(FRAC),     DIST(NUM)
```

Where:

```
DIST a    = a | UNIFORM a
UNIFORM a = a"-"a
NUM       = [0..INFINITY]
FRAC      = [0..1]
```

The following is a valid example of an `AGENTS` csv file:

```csv
name,  discount_rate,  threshold
a1,    0.8-0.11,       100
a2,    0.3,            0
```


## Phase parameters

Phases must be supplied in CSV format (`PHASES` above), with headers, as per the spec below. The column order must not be changed.

```csv
time,       cost,       revenue,    prob
DIST(NUM),  DIST(NUM),  DIST(NUM),  DIST(FRAC)
```

The following is a valid example of a `PHASES` csv file:

```csv
time,   cost,  revenue,  prob
2.2-5,  2,     0,        0.5
8,      2.5-8, 0,        0.9
10,     10.5,  100,      0.3-0.4
```

The phases csv file *must* contain at least two entries, since the last entry is assumed to be the market. As opposed to all other phases, the market will be converted from a single phase spanning multiple years into multiple phases each spanning a single year. Revenues and costs are assumed to linearly increase over the time period, while probability of success is assumed to remain constant.

To exemplify, the following market...

```csv
time,   cost,  revenue,  prob
3       100    1000      0.5
```

...would be converted into:

```csv
time,  cost,  revenue,  prob
1,     10,    100,      0.8408964152537145
1,     20,    200,      0.8408964152537145
1,     30,    300,      0.8408964152537145
1,     40,    400,      0.8408964152537145
```


## Interventions parameters

Interventions must be supplied in CSV format (`INTERVENTIONS` above), with headers, as per the spec below. The column order must not be changed.

```csv
name,    phase,      property,  operator,  operand
STRING,  DIST(INT),  PROP,      OPERATOR,  DIST(NUM)
```

Where, beyond the previously defined data types, the following definitions also hold:

```
PROP     = "REVENUE" | "COST" | "TIME" | "PROB" | "RISK"
OPERATOR = "+" | "-" | "*" | "/"
```

The `name` parameter will be used in the generated output when the simulation is run to identify worlds where a sample from the described intervention distribution have been used to alter the baseline phase input.

If the same `name` is used on multiple rows then these effects will all be applied (in the order that they are listed) whenever an intervention is applied. The interventions input csv file can therefore be thought of as listing interventions by listing intervention effects.

If the interventions input file is empty then the baseline world (i.e. whatever is described in the phases and config inputs) will still be explored.

Tip: Remember that doubling probability of success (`PROB` / PoS) is not the same as halving risk of failure (`RISK` / RoF).
`5 * RISK / 2  !=  2 * PROB`.
Therefore I suggest always expressing fractional reductions in `PROB` or `RISK` rather than increases to avoid accidentally transforming PoS to something outside of `(0,1]`. Choose whichever of the two you can express as a fractional decrease.

The following is a valid example of an `INTERVENTIONS` csv file:

```csv
name,    phase,  property,  operator,  operand
prize,   0-5,    revenue,   +,         0-2000
free,    0,      cost,      *,         0
free,    1,      cost,      *,         0
free,    2,      cost,      *,         0
```

In natural language the above example describes two interventions. One named `prize` and the other `free`. The former intervention (`prize`) consists of a single effect, while the latter has three effects. The former adds anything between 0 and 2000 to the revenue property of any of the phases between 0 and 5. Which phase it will be and how much it will add depends on what samples are drawn from the distributions in any given world. The latter intervention (`free`) reduces the cost of the first 3 phases (i.e. number 0, 2 and 1) down to zero, effectively making them free. The effects are applied in the order in which they appear, but in this particular example, the order of application does not affect the end result.


# Examples

A set of example input files can be found under `examples/[EX]/input`. Navigate to the folder `examples/[EX]` where `[EX]` is replaced by one of the example, and run the main script while passing all the input files as per the example below. Explore each of the input files to understand how input files should be structured.

```bash
cd examples/multiple
ruby ../../main.rb 10000 input/config.yaml input/phases.csv input/interventions.csv output/example.csv 1
```

In each example folder you will in `examples/[EX]/stats` find a bunch of R script that produce a number of different plots. The R scripts assume that your current working directory (`wd`) is the `examples/[EX]` folder. When using the `rscript` command in a terminal your `wd` is the folder from which you execute the scripts.

```bash
cd examples/multiple
rscript stats/cumulative-cashflow-01.R
```

If you're using RStudio you can manually set the working directory using the `setwd` command, or remove the lines from the example R scripts that read the output files and manually read them yourself.


# License

The MIT License (MIT).

Copyright 2018-20XX Christopher Okhravi

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
