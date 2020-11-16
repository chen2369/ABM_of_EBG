Game <- R6Class("Game",
                public = list(
                  times = NA,
                  p1type = NULL,
                  p2type = NULL,
                  downratio = NA,
                  game = NULL,
                  P1 = NULL,
                  P2 = NULL,
                  pic = NULL,
                  simulation_data = NULL,
                  thing = c("Price", "Dprice", "P1Cash", "P2Cash", "P1Stock", "P2Stock", "P1Value", "P2Value", "P1Asset", "P2Asset"),
                  market = Market$new(total=100),
                  # 初始化變項
                  initialize = function(P1type, P2type, downratio){
                    # stopifnot(is.numeric(Times), length(Times) == 1)
                    stopifnot(is.character(P1type), length(P1type) == 1)
                    stopifnot(is.character(P2type), length(P2type) == 1)
                    stopifnot(is.numeric(downratio), length(downratio) == 1)
                    # self$times = Times
                    self$p1type = P1type
                    self$p2type = P2type
                    self$downratio = downratio
                  },
                  playing = function(x){
                    # 目前以function取代
                    self$P1 <- Player$new(1,10000,10,self$p1type,100,self$downratio)
                    self$P2 <- Player$new(2,10000,10,self$p2type,100,self$downratio)
                    self$market = Market$new(total=100)                    
                    for (i in 1:self$market$total) {
                      self$P1$decide(self$market)
                      self$P2$decide(self$market)
                      if(i <= 20){
                        self$market$condition("Balance")
                      } else if (i <= 60){
                        self$market$condition("Bubble")
                      } else {
                        self$market$condition("Burst")
                      }
                      self$market$game(self$P1$decision[i],self$P2$decision[i])
                      self$P1$ending(self$market)
                      self$P2$ending(self$market)
                    }
                    data <- list(times = x, trials = 1:101,
                                 price = self$market$price, deltaPrice = self$market$dprice, 
                                 p1_cash = self$P1$cash, p2_cash = self$P2$cash,
                                 p1_stock = self$P1$stock, p2_stock = self$P2$stock,
                                 p1_value = self$P1$value, p2_value = self$P2$value,
                                 p1_asset = self$P1$asset, p2_asset = self$P2$asset,
                                 p1_decision = self$P1$decision, p2_decision = self$P2$decision)
                    return(data)
                  },
                  simulate = function(sim_times){
                    stopifnot(is.numeric(sim_times), length(sim_times) == 1)
                    self$simulation_data <- sapply(1:sim_times, self$playing, simplify = FALSE, USE.NAMES = TRUE)
                  },
                  # plotting = function(x){
                  #   self$game <- lapply(1:self$times, self$playing)
                  #   for (i in x:x) {
                  #     self$pic <- sapply(self$game, "[[", i) %>% 
                  #       data.frame() %>% 
                  #       add_column(trial = 1:101) %>% 
                  #       pivot_longer(-trial, names_to = "sim_times", values_to = "value") %>% 
                  #       group_by(trial) %>%
                  #       mutate(avg = mean(value)) %>%
                  #       ungroup() %>%
                  #       ggplot(aes(x = trial, y = value, group = sim_times)) +
                  #       geom_line(color = "skyblue") +
                  #       geom_line(aes(x = trial, y = avg, color = "darkred"), size = 1) + 
                  #       labs(x = paste(self$p1type,self$p2type,sep="_")) +
                  #       labs(y = self$thing[i]) +
                  #       theme(legend.position = "none")
                  #   }
                    # self$pic
                    # grid.arrange(self$pic[1:1])
                  # } ,  
                  lock_objects = F
                ))
