library(statsr)
library(dplyr)
library(shiny)
library(ggplot2)

data(ames)

ggplot(data = ames, aes(x = area)) +
  geom_histogram(binwidth = 250)

pop_sum <- ames %>%
  summarise(mu = mean(area), pop_med = median(area), 
            sigma = sd(area), pop_iqr = IQR(area),
            pop_min = min(area), pop_max = max(area),
            pop_q1 = quantile(area, 0.25),  # first quartile, 25th percentile
            pop_q3 = quantile(area, 0.75))  # third quartile, 75th percentile

plot_sample_data <- function(data, size, iters){
  samps <- vector("list", iters)
  #plots <- vector()
  
  for (i in seq(1, iters)) {
    samp <- data %>%
      sample_n(size=size) 
    summ <- samp %>%
      summarise(x_bar = mean(area), med = median(area), 
                         s = sd(area), iqr = IQR(area),
                         min = min(area), max = max(area),
                         q1 = quantile(area, 0.25),  # first quartile, 25th percentile
                         q3 = quantile(area, 0.75))
    p <- ggplot(data=samp, aes(x=area)) + geom_histogram(binwidth = 250) + labs(title = paste("Sample ", i))
    print(p)
    samps[[i]] <- summ
    
  }
  return(samps)
}

samps_3 <- plot_sample_data(ames, 50, 3)

plot_many_samples <- function(data, size, reps) {
  sample_means <- ames %>%
    rep_sample_n(size = size, reps = reps, replace = TRUE) %>%
    summarise(x_bar = mean(area))
  
  print(ggplot(data = sample_means, aes(x = x_bar)) +
    geom_histogram(binwidth = 20))
  return(sample_means)
}

samps_50 <- plot_many_samples(ames, 50, 15000)