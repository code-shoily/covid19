# Covid19

**WIP WARNING** This is a work in progress. See the disclaimer below.

This app reads Covid19 dataset from Johns Hopkins CSSE repository, loads it to a database and displays the data in a dashboard made with Phoenix LiveView.

Big thanks goes to Johns Hopkins CSSE and by extension, people behind all those data sources for keeping us updated.

## Other Branches and UI
As of right now, this branch (`main`) does not have any UI. UI is work in progress and will be updated soon.

There are two experimental UI branches:

1. [For ClojureScript + BulmaCSS](https://github.com/code-shoily/covid19/tree/clojurescript-experiment)
2. [For TailwindCSS](https://github.com/code-shoily/covid19/tree/mafinar/try-out-tailwind)

If you want to try out those branches, I'd suggest pull the data from the main branch following the instructions given here and then switch to those branches and compile. As the data syncing mechanism presented there are outdated and slow (30 minutes versus 3 minutes for global data sync)

## Setup

To start your Phoenix server:

* Pull the Covid19 dataset submodule with `git submodule update --init --recursive --progress --depth 1`
* Install dependencies with `mix deps.get`
* Create and migrate your database with `mix ecto.setup`
* Install Node.js dependencies with `cd assets && npm install`
* Start Phoenix endpoint with `mix phx.server`

Now that the system is setup, let's load some data.

To get the latest dataset from the repository, update the submodules with `git submodule update --recursive --remote`.

Now, fire up `iex -S mix` and in the REPL, type `Covid19.Source.sync_all()` to 
sync both global and US datasets. If you want to only sync US or Global datasets 
then you can type `Covid19.Source.sync_all(:global)` for global and 
`Covid19.Source.sync_all(:us)` for US.

There are some sensible aliases in `.iex.exs.copy` file. If you wish you can
append them in your own `.iex.exs`.

In order to keep the system updated, repeat the steps above.

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## FAQ

### Data Sync

TBD

## Screenshots

### Main Dashboard

TBA

### Detail View (WIP)

TBA

## Disclaimer

This app massages and displays based on curated datasets and does not attempt to produce or collect any beyond those sources. The datasets come with their own sets of "Terms and Conditions". I respect those and so should you!

This is my attempt to play with Phoenix LiveView and explore data, and by no means intended to be used by anything else, there can and will be wrong data, runtime errors, duplicates, and missing values compared to the data source. If you want to see actual data, google "Coronavirus Statistics" at your own risk, everyone seems to have a widget for it nowadays (Even those come with disclaimers, at least they should). I am doing this because I wanted to do learn some Phoenix LiveView, get less scared and more educated with Corona Virus (any, really) statistics, and convert some boredom (for now).

## Thank You!

* COVID-19 Data Repository by the Center for Systems Science and Engineering (CSSE) at Johns Hopkins University: https://github.com/CSSEGISandData/COVID-19
* [An interactive web-based dashboard to track COVID-19 in real time](https://www.thelancet.com/journals/laninf/article/PIIS1473-3099(20)30120-1/fulltext)
* [Desktop Visual Dashboard (JHU-CSSE)](https://www.arcgis.com/apps/opsdashboard/index.html#/bda7594740fd40299423467b48e9ecf6)
* [Mobile Visual Dashboard (JHU-CSSE)](http://www.arcgis.com/apps/opsdashboard/index.html#/85320e2ea5424dfaaa75ae62e5c06e61)
