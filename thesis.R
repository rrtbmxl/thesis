library(tidyverse)
library(pipeR)
library(lsr)
library(scales)
library(ggpubr)

data_integrate <- function(path, experiment) {

n <- dir(path) %>>% 
  map_chr(~ {paste(path , .x, sep='/')}) %>>% 
  (~ filepath) %>>% length()

df_vdac <- tibble()

for (i in 1:n) {
  
  if (i < n/2+1){
    
    vdac <- read_csv(filepath[i], col_names = F) %>% 
      select(col_train = 2, rt_train = 3, res_train = 4,
             col_test = 8, rt_test = 10, res_test = 11) %>%
      filter(res_train %in% c(1, 0)) %>% 
      mutate(sub = i + (experiment-1)*n,
             exp = experiment,
             col_train = ifelse(.$col_train == 103, 'high', 'low'),
             col_test = case_when(.$col_test == 103 ~ 'high',
                                  .$col_test == 114 ~ 'low',
                                  .$col_test == 111 ~ 'none'))
                }
  
  else {
  
    vdac <- read_csv(filepath[i], col_names = F) %>% 
      select(col_train = 2, rt_train = 3, res_train = 4,
             col_test = 8, rt_test = 10, res_test = 11) %>% 
      filter(res_train %in% c(1, 0)) %>% 
      mutate(sub = i + (experiment-1)*n,
             exp = experiment,
             col_train = ifelse(.$col_train == 114, 'high', 'low'),
             col_test = case_when(.$col_test == 114 ~ 'high',
                                  .$col_test == 103 ~ 'low',
                                  .$col_test == 111 ~ 'none')) 

       }
  
  df_vdac <- bind_rows(df_vdac, vdac)
  
               }

return(df_vdac)

}

vdac1 <- data_integrate("D:/data/dev_pre", 1)
vdac2 <- data_integrate("D:/data/dev_ado", 2)
vdac3 <- data_integrate("D:/data/money2", 3)
vdac4 <- data_integrate("D:/data/feature", 4)

dev <- bind_rows(vdac1, vdac2, vdac3)
com <- bind_rows(vdac3, vdac4)


##  reaction time of training phase in experiment 1
dev_train_rt <- dev %>% select(7, 8, 1, 2, 3) %>% 
  filter(res_train != 0) %>% 
  group_by(sub, exp, col_train) %>% 
  dplyr::summarise(mrt_train = mean(rt_train, trim = .005))

dev_train_rt_fit <- dev_train_rt %>% 
  aov(mrt_train ~ factor(exp)*factor(col_train) + Error(factor(sub)/factor(col_train)),
      data = .) %>% summary()

dev_train_rt_t1 <- filter(dev_train_rt, exp !=3) %>% 
  t.test(mrt_train ~ factor(exp), .)
dev_train_rt_t2 <- filter(dev_train_rt, exp !=2) %>% 
  t.test(mrt_train ~ factor(exp), .)
dev_train_rt_t3 <- filter(dev_train_rt, exp !=1) %>% 
  t.test(mrt_train ~ factor(exp), .)

dev_train_rt_d1 <- filter(dev_train_rt, exp !=3) %>% 
  cohensD(mrt_train ~ factor(exp), .)
dev_train_rt_d2 <- filter(dev_train_rt, exp !=2) %>% 
  cohensD(mrt_train ~ factor(exp), .)

dev_train_rt_plot <- dev %>% select(8, 1, 2, 3) %>% 
  filter(res_train != 0) %>% 
  group_by(exp, col_train) %>% 
  dplyr::summarise(mrt_train = mean(rt_train, trim = .005)*1000, 
                   se = sd(rt_train)/sqrt(n())*1000) %>% 
  ggplot(aes(factor(exp), mrt_train, fill = factor(col_train))) +
  geom_col(position = 'dodge', width = .6) + 
  geom_errorbar(aes(ymin = mrt_train - se, ymax = mrt_train + se), 
                position = position_dodge(.6), width = .2) + 
  coord_cartesian(ylim = c(700, 1000)) + 
  theme_classic() + 
  labs(x = '年龄', y = '平均反应时 (ms)', fill = '目标类型') + 
  scale_x_discrete(labels = c('学龄儿童', '青少年', '成年')) + 
  scale_fill_grey(labels = c('高价值', '低价值')) 
  

##  accuracy rate of training phase in experiment 1
dev_train_ac <- dev %>% select(7, 8, 1, 3) %>% 
  group_by(sub, exp, col_train) %>% 
  dplyr::summarise(ac_train = mean(res_train))

dev_train_ac_fit <- dev_train_ac %>% 
  aov(ac_train ~ factor(exp)*factor(col_train) + Error(factor(sub)/factor(col_train)),
      data = .) %>% summary()

dev_train_ac_t1 <- filter(dev_train_ac, exp !=3) %>% 
  t.test(ac_train ~ factor(exp), .)
dev_train_ac_t2 <- filter(dev_train_ac, exp !=2) %>% 
  t.test(ac_train ~ factor(exp), .)
dev_train_ac_t3 <- filter(dev_train_ac, exp !=1) %>% 
  t.test(ac_train ~ factor(exp), .)

dev_train_ac_d1 <- filter(dev_train_ac, exp !=3) %>% 
  cohensD(ac_train ~ factor(exp), .)
dev_train_ac_d2 <- filter(dev_train_ac, exp !=2) %>% 
  cohensD(ac_train ~ factor(exp), .)
dev_train_ac_d3 <- filter(dev_train_ac, exp !=1) %>% 
  cohensD(ac_train ~ factor(exp), .)

dev_train_ac_plot <- dev %>% select(8, 1, 3) %>% 
  group_by(exp, col_train) %>% 
  dplyr::summarise(ac_train = mean(res_train), 
                   se = sd(res_train)/sqrt(n())) %>% 
  ggplot(aes(factor(exp), ac_train, fill = factor(col_train))) +
  geom_col(position = 'dodge', width = .6) + 
  geom_errorbar(aes(ymin = ac_train - se, ymax = ac_train + se), 
                position = position_dodge(.6), width = .2) + 
  coord_cartesian(ylim = c(.7, 1)) + 
  theme_classic() + 
  labs(x = '年龄', y = '正确率', fill = '目标类型') + 
  scale_x_discrete(labels = c('学龄儿童', '青少年', '成年')) + 
  scale_fill_grey(labels = c('高价值', '低价值')) + 
  scale_y_continuous(labels = percent) 


##  reactioin time of test phase in experiment 1
dev_test_rt <- dev %>% select(7, 8, 4, 5, 6) %>% 
  filter(res_test != 0) %>% 
  group_by(sub, exp, col_test) %>% 
  dplyr::summarise(mrt_test = mean(rt_test, trim = .005))

dev_test_rt_fit <- dev_test_rt %>% 
  aov(mrt_test ~ factor(exp)*factor(col_test) + Error(factor(sub)/factor(col_test)),
      data = .) %>% summary()

dev_test_rt_t1 <- filter(dev_test_rt, exp !=3) %>% 
  t.test(mrt_test ~ factor(exp), .)
dev_test_rt_t2 <- filter(dev_test_rt, exp !=2) %>% 
  t.test(mrt_test ~ factor(exp), .)
dev_test_rt_t3 <- filter(dev_test_rt, exp !=1) %>% 
  t.test(mrt_test ~ factor(exp), .)

dev_test_rt_d1 <- filter(dev_test_rt, exp !=3) %>% 
  cohensD(mrt_test ~ factor(exp), .)
dev_test_rt_d2 <- filter(dev_test_rt, exp !=2) %>% 
  cohensD(mrt_test ~ factor(exp), .)

dev_test_rt_t4 <- filter(dev_test_rt, exp !='low') %>% 
  t.test(mrt_test ~ factor(col_test, levels = c('high', 'none')), ., paired = TRUE)
dev_test_rt_t5 <- filter(dev_test_rt, exp !='high') %>% 
  t.test(mrt_test ~ factor(col_test, levels = c('low', 'none')), ., paired = TRUE)
dev_test_rt_t6 <- filter(dev_test_rt, exp !='none') %>% 
  t.test(mrt_test ~ factor(col_test, levels = c('high', 'low')), ., paired = TRUE)

dev_test_rt_d4 <- filter(dev_test_rt, exp !='low') %>% 
  cohensD(mrt_test ~ factor(col_test, levels = c('high', 'none')), ., method = 'paired')
dev_test_rt_d5 <- filter(dev_test_rt, exp !='high') %>% 
  cohensD(mrt_test ~ factor(col_test, levels = c('low', 'none')), ., method = 'paired')


dev_test_rt_plot <- dev %>% select(8, 4, 5, 6) %>% 
  filter(res_test != 0) %>% 
  group_by(exp, col_test) %>% 
  dplyr::summarise(mrt_test = mean(rt_test, trim = .005)*1000, 
                   se = sd(rt_test)/sqrt(n())*1000) %>% 
  ggplot(aes(factor(exp), mrt_test, fill = col_test)) +
  geom_col(position = 'dodge', width = .8) + 
  geom_errorbar(aes(ymin = mrt_test - se, ymax = mrt_test + se), 
                position = position_dodge(.8), width = .2) + 
  coord_cartesian(ylim = c(700, 1000)) + 
  theme_classic() + 
  labs(x = '年龄', y = '平均反应时 (ms)', fill = '分心物类型') + 
  scale_x_discrete(labels = c('学龄儿童', '青少年', '成年')) + 
  scale_fill_grey(labels = c('高价值', '低价值', '无')) 


##  accuracy rate of test phase in experiment 1
dev_test_ac <- dev %>% select(7, 8, 4, 6) %>% 
  group_by(sub, exp, col_test) %>% 
  dplyr::summarise(ac_test = mean(res_test))

dev_test_ac_fit <- dev_test_ac %>% 
  aov(ac_test ~ factor(exp)*factor(col_test) + Error(factor(sub)/factor(col_test)),
      data = .) %>% summary()

dev_test_ac_t1 <- filter(dev_test_ac, exp !=3) %>% 
  t.test(ac_test ~ factor(exp), .)
dev_test_ac_t2 <- filter(dev_test_ac, exp !=2) %>% 
  t.test(ac_test ~ factor(exp), .)
dev_test_ac_t3 <- filter(dev_test_ac, exp !=1) %>% 
  t.test(ac_test ~ factor(exp), .)

dev_test_ac_d1 <- filter(dev_test_ac, exp !=3) %>% 
  cohensD(ac_test ~ factor(exp), .)
dev_test_ac_d2 <- filter(dev_test_ac, exp !=2) %>% 
  cohensD(ac_test ~ factor(exp), .)
dev_test_ac_d3 <- filter(dev_test_ac, exp !=1) %>% 
  cohensD(ac_test ~ factor(exp), .)

dev_test_ac_plot <- dev %>% select(8, 4, 5, 6) %>% 
  group_by(exp, col_test) %>% 
  dplyr::summarise(ac_test = mean(res_test), 
                   se = sd(res_test)/sqrt(n())) %>% 
  ggplot(aes(factor(exp), ac_test, fill = col_test)) +
  geom_col(position = 'dodge', width = .8) + 
  geom_errorbar(aes(ymin = ac_test - se, ymax = ac_test + se), 
                position = position_dodge(.8), width = .2) + 
  coord_cartesian(ylim = c(.7, 1)) + 
  theme_classic() + 
  labs(x = '年龄', y = '正确率', fill = '分心物类型') + 
  scale_x_discrete(labels = c('学龄儿童', '青少年', '成年')) + 
  scale_fill_grey(labels = c('高价值', '低价值', '无')) + 
  scale_y_continuous(labels = percent) 

##  combine the plots of Experiment 1
exp1_plot <- ggarrange(ggarrange(dev_train_rt_plot, dev_train_ac_plot, 
                                 ncol = 2, labels = c('A', 'B'), 
                                 common.legend = TRUE, legend = 'top'),
                       ggarrange(dev_test_rt_plot, dev_test_ac_plot, 
                                 ncol = 2, labels = c('C', 'D'), 
                                 common.legend = TRUE, legend = 'top'),
                       nrow = 2)


##  compare VDAC score of three age groups
vdac_com_fit <- dev %>% select(7, 8, 4, 5, 6) %>% 
  filter(res_test != 0) %>% 
  group_by(sub, exp, col_test) %>% 
  dplyr::summarise(mrt_test = mean(rt_test, trim = .005)) %>% 
  spread(col_test, mrt_test) %>% 
  mutate(diff = (high - none)*1000) %>% 
  aov(diff ~ factor(exp), .) %>% 
  summary()
  
vdac_com_plot <- dev %>% select(7, 8, 4, 5, 6) %>% 
  filter(res_test != 0) %>% 
  group_by(sub, exp, col_test) %>% 
  summarise(mrt_test = mean(rt_test, trim = .005)) %>% 
  spread(col_test, mrt_test) %>% 
  mutate(diff = (high - none)*1000) %>% 
  group_by(exp) %>% 
  summarise(mrt_diff = mean(diff), se = sd(diff)/sqrt(n())) %>% 
  ggplot(aes(factor(exp), mrt_diff, fill = factor(exp))) + 
  geom_col(position = 'dodge', width = .4) + 
  geom_errorbar(aes(ymin = mrt_diff - se, ymax = mrt_diff + se), 
                position = position_dodge(.4), width = .2) + 
  scale_y_continuous(expand = c(0, 0)) + 
  theme_classic() + 
  labs(x = '年龄', y = 'VDAC分数 (ms)') + 
  scale_x_discrete(labels = c('学龄儿童', '青少年', '成年')) + 
  scale_fill_grey() + guides(fill = FALSE)


##  reaction time of training phase in experiment 2
feat_train_rt <- vdac4 %>% select(7, 1, 2, 3) %>% 
  filter(res_train != 0) %>% 
  group_by(sub,col_train) %>% 
  summarise(mrt_train = mean(rt_train, trim= .005))

feat_train_rt_tt <- feat_train_rt %>% t.test(mrt_train ~ factor(col_train), 
                                             ., paired = TRUE)

com_train_rt <- com %>% select(7, 8, 1, 2, 3) %>% 
  filter(res_train != 0) %>% 
  group_by(sub, exp, col_train) %>% 
  dplyr::summarise(mrt_train = mean(rt_train, trim = .005))

com_train_rt_fit <- com_train_rt %>% 
  aov(mrt_train ~ factor(exp)*factor(col_train) + Error(factor(sub)/factor(col_train)),
      data = .) %>% summary()

com_train_rt_plot <- com %>% select(8, 1, 2, 3) %>% 
  filter(res_train != 0) %>% 
  group_by(exp, col_train) %>% 
  dplyr::summarise(mrt_train = mean(rt_train, trim = .005)*1000, 
                   se = sd(rt_train)/sqrt(n())*1000) %>% 
  ggplot(aes(factor(exp), mrt_train, fill = factor(col_train))) +
  geom_col(position = 'dodge', width = .6) + 
  geom_errorbar(aes(ymin = mrt_train - se, ymax = mrt_train + se), 
                position = position_dodge(.6), width = .2) + 
  coord_cartesian(ylim = c(700, 900)) + 
  theme_classic() + 
  labs(x = '搜索模式', y = '平均反应时 (ms)', fill = '目标类型') + 
  scale_x_discrete(labels = c('奇异刺激', '特征')) + 
  scale_fill_grey(labels = c('高价值', '低价值')) 


##  accuracy rate of training phase in experiment 2
feat_train_ac <- vdac4 %>% select(7, 1, 3) %>% 
  group_by(sub,col_train) %>% 
  summarise(ac_train = mean(res_train))

feat_train_ac_tt <- feat_train_ac %>% t.test(ac_train ~ factor(col_train), 
                                             ., paired = TRUE)

com_train_ac <- com %>% select(7, 8, 1, 3) %>% 
  group_by(sub, exp, col_train) %>% 
  dplyr::summarise(ac_train = mean(res_train))

com_train_ac_fit <- com_train_ac %>% 
  aov(ac_train ~ factor(exp)*factor(col_train) + Error(factor(sub)/factor(col_train)),
      data = .) %>% summary()

com_train_ac_plot <- com %>% select(8, 1, 3) %>% 
  group_by(exp, col_train) %>% 
  dplyr::summarise(ac_train = mean(res_train), 
                   se = sd(res_train)/sqrt(n())) %>% 
  ggplot(aes(factor(exp), ac_train, fill = factor(col_train))) +
  geom_col(position = 'dodge', width = .6) + 
  geom_errorbar(aes(ymin = ac_train - se, ymax = ac_train + se), 
                position = position_dodge(.6), width = .2) + 
  coord_cartesian(ylim = c(.8, 1)) + 
  theme_classic() + 
  labs(x = '搜索模式', y = '正确率', fill = '目标类型') + 
  scale_x_discrete(labels = c('奇异刺激', '特征')) + 
  scale_fill_grey(labels = c('高价值', '低价值')) + 
  scale_y_continuous(labels = percent) 


##  reaction time of test phase in experiment 2
feat_test_rt <- vdac4 %>% select(7, 4, 5, 6) %>% 
  filter(res_test != 0) %>% 
  group_by(sub,col_test) %>% 
  summarise(mrt_test = mean(rt_test, trim= .005))

feat_test_rt_fit <- feat_test_rt %>% aov(mrt_test ~ factor(col_test) + 
                                        Error(factor(sub)/factor(col_test)),
                                      data = .) %>% summary()

com_test_rt <- com %>% select(7, 8, 4, 5, 6) %>% 
  filter(res_test != 0) %>% 
  group_by(sub, exp, col_test) %>% 
  dplyr::summarise(mrt_test = mean(rt_test, trim = .005))

com_test_rt_fit <- com_test_rt %>% 
  aov(mrt_test ~ factor(exp)*factor(col_test) + Error(factor(sub)/factor(col_test)),
      data = .) %>% summary()

com_test_rt_t4 <- filter(com_test_rt, exp !='low') %>% 
  t.test(mrt_test ~ factor(col_test, levels = c('high', 'none')), ., paired = TRUE)
com_test_rt_t5 <- filter(com_test_rt, exp !='high') %>% 
  t.test(mrt_test ~ factor(col_test, levels = c('low', 'none')), ., paired = TRUE)
com_test_rt_t6 <- filter(com_test_rt, exp !='none') %>% 
  t.test(mrt_test ~ factor(col_test, levels = c('high', 'low')), ., paired = TRUE)

com_test_rt_d4 <- filter(com_test_rt, exp !='low') %>% 
  cohensD(mrt_test ~ factor(col_test, levels = c('high', 'none')), ., method = 'paired')
com_test_rt_d5 <- filter(com_test_rt, exp !='high') %>% 
  cohensD(mrt_test ~ factor(col_test, levels = c('low', 'none')), ., method = 'paired')

com_test_rt_plot <- com %>% select(8, 4, 5, 6) %>% 
  filter(res_test != 0) %>% 
  group_by(exp, col_test) %>% 
  dplyr::summarise(mrt_test = mean(rt_test, trim = .005)*1000, 
                   se = sd(rt_test)/sqrt(n())*1000) %>% 
  ggplot(aes(factor(exp), mrt_test, fill = col_test)) +
  geom_col(position = 'dodge', width = .8) + 
  geom_errorbar(aes(ymin = mrt_test - se, ymax = mrt_test + se), 
                position = position_dodge(.8), width = .2) + 
  coord_cartesian(ylim = c(700, 900)) + 
  theme_classic() + 
  labs(x = '搜索模式', y = '平均反应时 (ms)', fill = '分心物类型') + 
  scale_x_discrete(labels = c('奇异刺激', '特征')) + 
  scale_fill_grey(labels = c('高价值', '低价值', '无')) 


##  accuracy rate of test phase in experiment 2
feat_test_ac <- vdac4 %>% select(7, 4, 6) %>% 
  group_by(sub,col_test) %>% 
  summarise(ac_test = mean(res_test))

feat_test_ac_fit <- feat_test_ac %>% aov(ac_test ~ factor(col_test) + 
                                        Error(factor(sub)/factor(col_test)),
                                      data = .) %>% summary()

com_test_ac <- com %>% select(7, 8, 4, 5, 6) %>% 
  group_by(sub, exp, col_test) %>% 
  dplyr::summarise(ac_test = mean(res_test))

com_test_ac_fit <- com_test_ac %>% 
  aov(ac_test ~ factor(exp)*factor(col_test) + Error(factor(sub)/factor(col_test)),
      data = .) %>% summary()

com_test_ac_plot <- com %>% select(8, 4, 5, 6) %>% 
  group_by(exp, col_test) %>% 
  dplyr::summarise(ac_test = mean(res_test), 
                   se = sd(res_test)/sqrt(n())) %>% 
  ggplot(aes(factor(exp), ac_test, fill = col_test)) +
  geom_col(position = 'dodge', width = .8) + 
  geom_errorbar(aes(ymin = ac_test - se, ymax = ac_test + se), 
                position = position_dodge(.8), width = .2) + 
  coord_cartesian(ylim = c(.8, 1)) + 
  theme_classic() + 
  labs(x = '搜索模式', y = '正确率', fill = '分心物类型') + 
  scale_x_discrete(labels = c('奇异刺激', '特征')) + 
  scale_fill_grey(labels = c('高价值', '低价值', '无')) + 
  scale_y_continuous(labels = percent)


##  combine the plots of Experiment 2
exp2_plot <- ggarrange(ggarrange(com_train_rt_plot, com_train_ac_plot, 
                                 ncol = 2, labels = c('A', 'B'), 
                                 common.legend = TRUE, legend = 'top'),
                       ggarrange(com_test_rt_plot, com_test_ac_plot, 
                                 ncol = 2, labels = c('C', 'D'), 
                                 common.legend = TRUE, legend = 'top'),
                       nrow = 2)


##  compare VDAC score of two different search modes
vdac_com_tt <- com %>% select(7, 8, 4, 5, 6) %>% 
  filter(res_test != 0) %>% 
  group_by(sub, exp, col_test) %>% 
  dplyr::summarise(mrt_test = mean(rt_test, trim = .005)) %>% 
  spread(col_test, mrt_test) %>% 
  mutate(diff = (high - none)*1000) %>% 
  t.test(diff ~ factor(exp), .)

vdac_com_plot2 <- com %>% select(7, 8, 4, 5, 6) %>% 
  filter(res_test != 0) %>% 
  group_by(sub, exp, col_test) %>% 
  summarise(mrt_test = mean(rt_test, trim = .005)) %>% 
  spread(col_test, mrt_test) %>% 
  mutate(diff = (high - none)*1000) %>% 
  group_by(exp) %>% 
  summarise(mrt_diff = mean(diff), se = sd(diff)/sqrt(n())) %>% 
  ggplot(aes(factor(exp), mrt_diff, fill = factor(exp))) + 
  geom_col(position = 'dodge', width = .3) + 
  geom_errorbar(aes(ymin = mrt_diff - se, ymax = mrt_diff + se), 
                position = position_dodge(.3), width = .2) + 
  scale_y_continuous(expand = c(0, 0)) + 
  theme_classic() + 
  labs(x = '搜索模式', y = 'VDAC分数 (ms)') + 
  scale_x_discrete(labels = c('奇异刺激', '特征')) + 
  scale_fill_grey() + guides(fill = FALSE)


##  effect of reward consistency between trials
n <- dir("D:/data/money2") %>>% 
  map_chr(~ {paste("D:/data/money2" , .x, sep='/')}) %>>% 
  (~ filepath) %>>% length()

df_consis <- tibble()

for (i in 1:n) {
  
  if (i < n/2+1){

    consis <- read_csv(filepath[i], col_names = FALSE) %>%
      select(trialno = 1, col = 2, rt = 3, sum = 7) %>%
      mutate(point = diff(c(0,.$sum)),
             pre = c(NA, point[1:nrow(.) - 1])) %>% 
      filter(!is.na(pre)) %>% 
      mutate(sub = i,
             cur = if_else(.$col == 103, 'high', 'low'),
             pre = if_else(.$pre > .1, 'high', 'low')) %>% 
      select(7, 1, 6, 8, 3)

}

  else {
    
    consis <- read_csv(filepath[i], col_names = FALSE) %>%
      select(trialno = 1, col = 2, rt = 3, sum = 7) %>%
      mutate(point = diff(c(0,.$sum)),
             pre = c(NA, point[1:nrow(.) - 1])) %>% 
      filter(!is.na(pre)) %>% 
      mutate(sub = i,
             cur = if_else(.$col == 114, 'high', 'low'),
             pre = if_else(.$pre > .1, 'high', 'low')) %>% 
      select(7, 1, 6, 8, 3)
    
  }
  
  df_consis <- bind_rows(df_consis, consis)
  
}

df_consis_fit <- df_consis %>% group_by(sub, pre, cur) %>% 
  summarise(mrt = mean(rt, trim = .005)) %>% 
  aov(mrt ~ factor(pre)*factor(cur) + Error(factor(sub)/(factor(pre)*factor(cur))),
      data = .) %>% summary()

df_consis_fit_low <- df_consis %>% group_by(sub, pre, cur) %>% 
  summarise(mrt = mean(rt, trim = .005)) %>% 
  filter(cur == 'low') %>% 
  aov(mrt ~ factor(pre) + Error(factor(sub)/factor(pre)), data = .) %>% 
  summary()

df_consis_fit_high <- df_consis %>% group_by(sub, pre, cur) %>% 
  summarise(mrt = mean(rt, trim = .005)) %>% 
  filter(cur == 'high') %>% 
  aov(mrt ~ factor(pre) + Error(factor(sub)/factor(pre)), data = .) %>% 
  summary()

df_consis_plot <- df_consis %>% group_by(pre, cur) %>% 
  summarise(mrt = mean(rt)*1000) %>% 
  ggplot(aes(pre, mrt, group = factor(cur), color = factor(cur))) +
  geom_line(size = 2) + 
  geom_point(aes(shape = factor(cur)), size = 3) + 
  scale_y_continuous(limits = c(750, 850)) + 
  theme_classic() + 
  scale_color_brewer(palette = 'Paired', labels = c('高价值', '低价值')) + 
  scale_shape_discrete(labels = c('高价值', '低价值')) + 
  labs(x = '先前试次奖励', y = '平均反应时 (ms)', 
       color = '当前试次目标', shape = '当前试次目标') + 
  scale_x_discrete(labels = c('高价值', '低价值'))

