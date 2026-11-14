
<!-- README.md is generated from README.Rmd. Please edit that file -->

# 

<!-- #region -->

## Purpose

The purpose of this assignment was to develop a package that could
extract a professional tennis player’s career from [Tennis
Abstract](https://www.tennisabstract.com/), a website that records the
match statistics of professional tennis players’ matches throughout
their career.

### Package Contents

This package contains two main functions: `getcareertable()` and
`getcareerplot()`

`getcareertable()`

- A data frame containing five columns:
  - “Date”
  - “Player_Age”
  - “Opponent_Age”
  - “Age_Difference”
  - “Player_Outcome”

*for more information, see `getcareertable_DICTIONARY.txt` in /R/
folder*

`getcareertable()` - A scatter plot of all matches a professional tennis
player has won or lost in their career, and their age relative to their
opponents each match. The layout of the plot is directly influenced by
the one created for Serena Williams in the New York Times article
[“Serena Williams Dominated Her Generation, Then the Next One,
Too.”](https://www.nytimes.com/interactive/2022/08/28/sports/tennis/serena-age-opponents.html)
by Leo Dominguez and Sara Ziegler.

## File Structure

    |── R/
    |   |── getcareerdatafromweb.R            # auxiliary function
    |   |── getcareertable_DICTIONARY.txt     # metadata for data frame from getcareertable() function
    |   |── getcareertable.R                  # main function
    |   |── getcareerplot.R                   # main function
    |   |── getmensoppsages.R                 # auxiliary function
    |   |── getwomensoppsbdays.R              # auxiliary function
    |── .Rbuildignore
    |── .gitignore
    |── DESCRIPTION
    |── LICENSE
    |── LICENSE.md
    |── NAMESPACE
    |── instructions.md
    |── tennisplayercareer.Rproj

## Dependencies

### Language

I used R as my main coding language. Here is a helpful
[guide](https://www.r-project.org/) on how to install R. I used RStudio
for its user-friendly interface, but it is not necessary for the code to
run. If you would like to install RStudio, here is a
[guide](https://rstudio-education.github.io/hopr/starting.html#rstudio)
on how to do so. - R - version: 4.4.2 - RStudio - version: 2024.12.0.467

### R packages used

Press on the name of the package for more information on the commands
and contents. -
[ggplot2](https://ggplot2.tidyverse.org/articles/ggplot2.html) (for data
visualization) - version: 4.0.3 -
[lubridate](https://lubridate.tidyverse.org/) (for working with dates) -
version: 1.9.5 -
[stringr](https://rstudio.github.io/cheatsheets/html/strings.html) (for
working with character strings) - version: 1.6.0 -
[rvest](https://rvest.tidyverse.org/) (for html extraction) - version:
1.0.5

## Installation of Package

You can install the development version of tennisplayercareer from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("UCB-stat159-f26/hw03-chloeomeanylucas")
```

## Example

This is a basic example which shows you how to solve a common problem:
<!-- #endregion -->

``` r

## basic example code
```

What is special about using `README.Rmd` instead of just `README.md`?
You can include R chunks like so:

You’ll still need to render `README.Rmd` regularly, to keep `README.md`
up-to-date. `devtools::build_readme()` is handy for this.

You can also embed plots, for example:

In that case, don’t forget to commit and push the resulting figure
files, so they display on GitHub and CRAN.

## Special Considerations

### Omitted Data

- When extracting the data from Tennis Abstract in the form of .js
  (Javascript) files, there were lines that were missing either an
  tennis player’s opponent’s birthday or age, for female and male
  players respectively. I tracked these using the `unincluded_indices`
  variable in the auxiliary functions `getwomensoppsbdays()` and
  `getmensoppsages()`. I then used `unincluded_indices` to omit those
  lines from all future calculations.

### Inaccessible Data

- Some player’s data could not be extracted because the URLs for the .js
  files did not exist. An example was for the player Ben Shelton. Try
  `https://www.tennisabstract.com/jsmatches/BenShelton.js` in your
  browser (I used Google Chrome). This is not the case for Serena
  Williams, and this url
  `https://www.tennisabstract.com/jsmatches/SerenaWilliams.js` will
  open. This package is, therefore, not suited for every player on
  Tennis Abstract. For future directions, I might explore extracting
  data in different ways.

## Reflection
