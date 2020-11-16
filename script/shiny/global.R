library(shiny)
library(tidyverse)
library(R6)
library(gt)
source("market.R")
source("player.R")
source("game.R")

# for ui.R
# 4種type
ratiolist <- c("90 / 85 / 80 / 50", "100 / 85 / 70 / 50")
typelist <- c("Herd", "Inversive", "Hedge", "Noise")
plot_choices <- c("stock", "cash", "asset", "decision")

# for server.R