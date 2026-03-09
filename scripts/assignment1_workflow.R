#install and load necessary packages 
install.packages('nlme')
library(nlme)
data(Orthodont)
df<-Orthodont
attach(df)
library(lme4)
library(lmerTest)
library(ggplot2)
library(dplyr)
library(tidyr)
library(performance) 
library(psych)

##PART 1
#summary stats by age:
summary_table_1 <- df %>%
  filter(age %in% c(8, 10, 12, 14)) %>%
  group_by(age) %>%
  summarise(
    N = n(),
    Mean = round(mean(distance), 0),
    SD = round(sd(distance), 1)
  )
print(summary_table_1)

#summary stats by sex:
summary_table_2 <- df %>%
  filter(age %in% c(8, 10, 12, 14)) %>%
  group_by(Sex) %>%
  summarise(
    N = n(),
    Mean = round(mean(distance), 0),
    SD = round(sd(distance), 1)
  )
print(summary_table_2)

#spaghetti plot:
df_spagplot<- ggplot(df, aes(x = age, y = distance, group = Subject, colour=Sex)) +
  geom_line(alpha = 0.4) +
  geom_point(size = 1.5, alpha = 0.5) +
  labs(
    x = "Age of Children (years)",
    y = "Distance (mm)") +
  theme_minimal(base_size = 14) +
  scale_x_continuous(breaks = c(8, 10, 12, 14)) +
  scale_y_continuous(limits = c(15,35), 
                     breaks = seq(15, 35, by = 5)) +
  scale_colour_manual(values = c('Female'='red', 'Male'='blue'))


print(df_spagplot)
ggsave("distance_by_age.png", width = 6, height = 4)

ggsave(
  "spag_plot.png",
  plot = df_spagplot,
  width = 7,
  height = 5,
  dpi = 300
)


###PART 2

#model 1 (random intercept, fixed slope):
model_1 <- lmer(distance ~ age + (1 | Subject), data = df)
summary(model_1)

#model 2 (random intercept, fixed slope):
model_2 <- lmer(distance ~ age * Sex + (1 | Subject), data = df)
summary(model_2)

#model 3 (random intercept and slope):
model_3 <- lmer(distance ~ age * Sex + (1 + age | Subject), data = df)
summary(model_3)

#Vvisualising slopes for models:
df$pred_ri <- predict(model_2)
df$pred_rs <- predict(model_3)

m2_plot <- ggplot(df, aes(x = age, y = distance, group = Subject, colour = Sex)) +
  geom_point(size = 3, alpha = 0.6) +
  geom_line(aes(y = pred_ri), alpha = 0.6) +
  labs(
    x = "Age",
    y = "Distance"
  ) +
  theme_minimal(base_size = 14)

m3_plot <- ggplot(df, aes(x = age, y = distance, group = Subject, colour = Sex)) +
  geom_point(size = 3, alpha = 0.6) +
  geom_line(aes(y = pred_rs), alpha = 0.6) +
  labs(
    x = "Age",
    y = "Distance"
  ) +
  theme_minimal(base_size = 14)

combined_plot <- m2_plot + m3_plot
print(combined_plot)
ggsave(
  "slopes.png",
  plot = combined_plot,
  width = 7,
  height = 5,
  dpi = 300
)

#comparing models using AIC:
AIC(model_2)
AIC(model_3) 
anova(model_2, model_3)

#assessing variance of models:
VarCorr(model_2)
VarCorr(model_3)

#getting ICC for random intercepts model:
library(performance)
icc(model_2)


###PART 3

#plotting scatter plot of residuals vs fitted values:
residuals_data <- data.frame(
  fitted = fitted(model_2),
  residuals = resid(model_2)
)
plot(residuals_data)

residuals_plot <- ggplot(residuals_data, aes(x = fitted, y = residuals)) +
  geom_point(alpha = 0.5, color = "blue") +
  geom_hline(yintercept = 0, linetype = "dashed", color = "red") +
  geom_smooth(method = "loess", se = FALSE, color = "orange") +
  labs(
    x = "Fitted Values",
    y = "Residuals") +
  theme_minimal(base_size = 12)

print(residuals_plot) 
ggsave(
  "residuals_plot.png",
  plot = residuals_plot,
  width = 7,
  height = 5,
  dpi = 300
)

#qqplot of residuals:
qq_res <- ggplot(residuals_data, aes(sample = residuals)) +
  stat_qq(color = "#38a169") +
  stat_qq_line(color = "red") +
  labs(
    x = "Theoretical Quantiles",
    y = "Sample Quantiles") +
  theme_minimal(base_size = 12)

print(qq_res)
ggsave(
  "qq_res.png",
  plot = qq_res,
  width = 7,
  height = 5,
  dpi = 300
)

#qqplot of random intercept:
re <- ranef(model_2)$Subject
qq_ran <- ggplot(data.frame(x = re[,1]), aes(sample = x)) +
  stat_qq(color = "#805ad5") +
  stat_qq_line(color = "red") +
  labs(
    x = "Theoretical Quantiles",
    y = "Random Intercepts") +
  theme_minimal(base_size = 12)

print(qq_ran)
ggsave(
  "qq_ran.png",
  plot = qq_ran,
  width = 7,
  height = 5,
  dpi = 300
)