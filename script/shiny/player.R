# library(tidyverse)
# library(R6)
#Player Class
Player <- R6Class("Player",
                  public = list(
                    type = NULL,     #玩家類型
                    id = NA,         #偵測何位玩家
                    cash = NULL,     #現金
                    stock = NULL,    #股票
                    value = NULL,    #股票價值
                    asset = NULL,    #總資產
                    decision = NULL, #決策
                    total = NA,      #總回合數
                    downratio = NA,  #意願下降幅度
                    # 初始化變項
                    initialize = function(id,cash,stock,type,total,downratio){
                      # 判斷格式
                      stopifnot(is.numeric(id), length(id) == 1)
                      stopifnot(is.numeric(cash), length(cash) == 1)
                      stopifnot(is.numeric(stock), length(stock) == 1)
                      stopifnot(is.numeric(total), length(total) == 1)
                      stopifnot(is.character(type), length(type) == 1)
                      stopifnot(is.numeric(downratio), length(downratio) == 1)
                      # 初始值設定
                      self$cash = vector("numeric", total)
                      self$stock = vector("numeric", total)
                      self$value = vector("numeric", total)
                      self$asset = vector("numeric", total)
                      self$decision = vector("character", total)
                      self$id = id
                      self$type = type
                      self$downratio = downratio
                      self$cash[1] = cash 
                      self$stock[1] = stock
                      self$value[1] = stock * 100
                      self$asset[1] = cash + stock * 100
                      self$decision[101] = "N"
                      self$decision[101] = "N"
                    },
                    # 決策
                    decide = function(Market){
                      # 價格波動變化
                      # browser()
                      if (self$type == "Noise"){
                        Prob = rmultinom(1, size = 1, prob = c(0.3, 0.3, 0.3))
                      } else {
                        if(Market$trial == 1){
                          Prob = rmultinom(1, size = 1, prob = c(0.4, 0.2, 0.4))
                        } else {
                          la = 1     #增加資產意願
                          lc = 1     #增加現金意願
                          if (self$id == 1){
                            # 對方不買
                            if(Market$mcol != 1){    # mcol為p2行動，B=1 N=2 S=3
                              if(self$type == "Herd"){
                                la = self$downratio             # 少買
                              } else if(self$type == "Inversive" || self$type == "Hedge"){
                                lc = self$downratio             # 少賣
                              } 
                            }
                            # 對方不賣
                            if (Market$mcol != 3){
                              if(self$type == "Herd"){
                                lc = self$downratio             # 少賣
                              } else if(self$type == "Inversive"){
                                la = self$downratio             # 少買
                              } 
                            }
                          } else if (self$id == 2){
                            # 對方不買
                            if(Market$mrow != 1){    # mrow為p1行動，B=1 N=2 S=3
                              if(self$type == "Herd"){
                                la = self$downratio             # 少買
                              } else if(self$type == "Inversive" || self$type == "Hedge"){
                                lc = self$downratio             # 少賣
                              } 
                            }
                            # 對方不賣
                            if (Market$mrow != 3){
                              if(self$type == "Herd"){
                                lc = self$downratio             # 少賣
                              } else if(self$type == "Inversive"){
                                la = self$downratio             # 少買
                              } 
                            }
                          }
                          probasset = la
                          probcash = lc
                          # 60期後買股意願下降
                          if (Market$trial >= 60){
                            probasset = la * (0.3+0.00000028*(Market$trial-100)^4)
                          }
                          # 價格變動影響
                          if(Market$dprice[Market$trial]/Market$price[Market$trial-1] > 0.061){
                            ins1 = 90
                            ins2 = 10
                          } else if(Market$dprice[Market$trial]/Market$price[Market$trial-1] > 0.031){
                            ins1 = 85
                            ins2 = 15
                          } else if(Market$dprice[Market$trial]/Market$price[Market$trial-1] > 0){
                            ins1 = 80
                            ins2 = 20
                          } else if(Market$dprice[Market$trial]/Market$price[Market$trial-1] == 0){
                            ins1 = 50
                            ins2 = 50
                          } else if(Market$dprice[Market$trial]/Market$price[Market$trial-1] > -0.031){
                            ins1 = 20
                            ins2 = 80
                          } else if(Market$dprice[Market$trial]/Market$price[Market$trial-1] > -0.061){
                            ins1 = 15
                            ins2 = 85
                          } else {
                            ins1 = 10
                            ins2 = 90
                          }
                          # BNS機率
                          ps = switch(self$type,
                                      Herd=probcash*ins2,
                                      Inversive=probcash*ins1,
                                      Hedge=probcash*ins1)
                          pb = switch(self$type,
                                      Herd=probasset*ins1,
                                      Inversive=probasset*ins2,
                                      Hedge=0.7*probasset*ins2)
                          pn = 100 - ps - pb
                          
                          Prob = rmultinom(1, size = 1, prob = c(pb,pn,ps))
                        }
                      }
                      
                      # 判斷變動
                      if(Prob[1,1]){
                        if(self$cash[Market$trial] > Market$price[Market$trial]){
                          self$decision[Market$trial] = "B"
                          self$cash[Market$trial+1] = self$cash[Market$trial] - Market$price[Market$trial]
                          self$stock[Market$trial+1] = self$stock[Market$trial] + 1
                        } else {
                          self$decision[Market$trial] = "N"
                          self$cash[Market$trial+1] = self$cash[Market$trial]
                          self$stock[Market$trial+1] = self$stock[Market$trial]
                        }
                      }
                      else if(Prob[2,1]){
                        self$decision[Market$trial] = "N"
                        self$cash[Market$trial+1] = self$cash[Market$trial]
                        self$stock[Market$trial+1] = self$stock[Market$trial]
                      }
                      else {
                        if(self$stock[Market$trial] > 0){
                          self$decision[Market$trial] = "S"
                          self$cash[Market$trial+1] = self$cash[Market$trial] + Market$price[Market$trial]
                          self$stock[Market$trial+1] = self$stock[Market$trial] - 1}
                        else {
                          self$decision[Market$trial] = "N"
                          self$cash[Market$trial+1] = self$cash[Market$trial]
                          self$stock[Market$trial+1] = self$stock[Market$trial]
                        }
                      }
                    },
                    # 結算
                    ending = function(Market){
                      self$value[Market$trial] = self$stock[Market$trial-1] * Market$price[Market$trial-1]
                      self$asset[Market$trial] = self$cash[Market$trial-1] + self$value[Market$trial-1]
                    },  
                    lock_objects = F
                  ))
