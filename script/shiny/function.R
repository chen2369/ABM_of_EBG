# library(tidyverse)
# library(R6)
source("market.R")
source("player.R")
source("game.R")
# 模擬的function
# Playgame <- function(times, P1type, P2type){
#   market <- Market$new(total=100)
#   P1 <- Player$new(1,10000,10,P1type,100)   #P1
#   P2 <- Player$new(2,10000,10,P2type,100)   #P2
#   for (i in 1:market$total) {
#     P1$decide(market)
#     P2$decide(market)
#     if(i <= 20){
#       market$condition("Balance")
#     } else if (i <= 60){
#       market$condition("Bubble")
#     } else {
#       market$condition("Burst")
#     }
#     market$game(P1$decision[i],P2$decision[i])
#     P1$ending(market)
#     P2$ending(market)
#   }
#   data <- list(
#     times = times,             trials = 1:101,
#     price = market$price,      deltaPrice = market$dprice,
#     p1_cash = P1$cash,         p2_cash = P2$cash,
#     p1_stock = P1$stock,       p2_stock = P2$stock,
#     p1_value = P1$value,       p2_value = P2$value,
#     p1_asset = P1$asset,       p2_asset = P2$asset,
#     p1_decision = P1$decision, p2_decision = P2$decision
#   )
#   return(data)
# }

# 4種type
# typelist <- c("Herd", "Inversive", "Hedge", "Noise")
# i = 2
# j = 2
# 執行16種組合
# for (i in 1:4) {
#   for(j in i:4) {
    # for(k in c(3,7)){
# run <- sapply(1:100, FUN = Playgame, P1type = typelist[i], P2type = typelist[j])

# game <- Game$new("Inversive", "Inversive")
# game$simulate(50)
# a <- game$simulation_data
# View(game$simulation_data[[1]])



# hh <- sapply(run, "[[", 2) %>% 
#   data.frame() %>%
#   mutate(trial = 1:101) %>% 
#   pivot_longer(-trial, names_to = "sim_times", values_to = "value") %>% 
#   ggplot(aes(x = trial, y = value, group = sim_times)) +
#   geom_line(color = "darkgray", alpha = 0.5) +
#   ylim(0, 400) +
#   labs(y = "Cash") +
#   labs(title = paste0(typelist[i],"_",typelist[j])) +
#   theme_classic()
      # ggsave(paste0(typelist[i],"_",typelist[j],"Cash",k,".png"), hh, "png")
    # }
#   }
# }