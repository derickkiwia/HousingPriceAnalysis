# link to dataset https://www.kaggle.com/datasets/yasserh/housing-prices-dataset/data

#------------------- DATA IMPORTATION AND CLEANING-----------------------------------
# Read the data from CSV file
housing_data_raw = read.csv("Housing.csv", header = TRUE)

#Load necessary library
library(ggplot2)
library(dplyr)
library(scales)

# Convert 'yes'/'no' to 1/0 for specified columns
housing_data_raw <- housing_data_raw %>%
  mutate(mainroad = ifelse(mainroad == "yes", 1, 0),
         guestroom = ifelse(guestroom == "yes", 1, 0),
         basement = ifelse(basement == "yes", 1, 0),
         hotwaterheating = ifelse(hotwaterheating == "yes", 1, 0),
         airconditioning = ifelse(airconditioning == "yes", 1, 0),
         prefarea = ifelse(prefarea == "yes", 1,0))


# Transform 'furnishingstatus' from categorical to numerical
housing_data_raw$furnishingstatus_num <- as.integer(factor(housing_data_raw$furnishingstatus, levels = c("unfurnished", "semi-furnished", "furnished"), labels = c(1, 2, 3)))

# Print the updated dataframe to verify changes
head(housing_data_raw)

#Remove 'furnishingstatus' from the dataframe
housing_data <- housing_data_raw[,-13]

# Print the updated data frame to verify changes
print(head(housing_data))


# Split the data into training and testing sets
set.seed(123) # for reproducibility
index <- sample(1:nrow(housing_data), size = 0.8 * nrow(housing_data)) # 80% for training
train_data <- housing_data[index, ]
test_data <- housing_data[-index, ]

# Normalize the training data
max_value <- max(train_data$some_numeric_column, na.rm = TRUE)
min_value <- min(train_data$some_numeric_column, na.rm = TRUE)
train_data$some_numeric_column <- (train_data$some_numeric_column - min_value) / (max_value - min_value)

# Normalize the testing data using the same scale
test_data$some_numeric_column <- (test_data$some_numeric_column - min_value) / (max_value - min_value)


#--------------- LINEAR RERGRESSION ON THE DATA---------------------------------------

#linear regression of price and area
Reg_1=lm(price~area,housing_data) 
print(summary(Reg_1))
plot(housing_data$area,housing_data$price,xlab="area",ylab="price",cex.lab=1.5,cex.axis=1.5,pch=16,col="blue")
abline(Reg_1,col="red")
AIC(Reg_1)

#linear regression using robust regression analysis 
Reg_1_rlm=rlm(price~area,housing_data,psi=psi.huber) 
print(summary(Reg_1_rlm))
plot(housing_data$area,housing_data$price,xlab="area",ylab="price",cex.lab=1.5,cex.axis=1.5,pch=16,col="blue")
abline(Reg_1_rlm,col="green")
abline(Reg_1,col="red")
AIC(Reg_1_rlm)
#AIC has increased indicating an increase in model performance after adjusting the linear regression for outliers

#linear regression of price and bedrooms
Reg_2=lm(price~bedrooms,housing_data) 
print(summary(Reg_2))
plot(housing_data$bedrooms,housing_data$price,xlab="bedrooms",ylab="price",cex.lab=1.5,cex.axis=1.5,pch=16,col="blue")
abline(Reg_2,col="red")

#linear regression of price and bathrooms
Reg_3=lm(price~bathrooms,housing_data) 
print(summary(Reg_3))
plot(housing_data$bathrooms,housing_data$price,xlab='bathrooms',ylab="price",cex.lab=1.5,cex.axis=1.5,pch=16,col="blue")
abline(Reg_3,col="red")

#linear regression of price and stories
Reg_4=lm(price~stories,housing_data) 
print(summary(Reg_4))
plot(housing_data$stories,housing_data$price,xlab='stories',ylab="price",cex.lab=1.5,cex.axis=1.5,pch=16,col="blue")
abline(Reg_4,col="red")

#linear regression of price and parking
Reg_5=lm(price~parking,housing_data) 
print(summary(Reg_5))
plot(housing_data$parking,housing_data$price,xlab='parking',ylab="price",cex.lab=1.5,cex.axis=1.5,pch=16,col="blue")
abline(Reg_5,col="red")

#linear regression of price and airconditioning
Reg_6=lm(price~airconditioning,housing_data) 
print(summary(Reg_6))
plot(housing_data$airconditioning,housing_data$price,xlab="airconditioning",ylab="price",cex.lab=1.5,cex.axis=1.5,pch=16,col="blue")
abline(Reg_6,col="red")

#Multiple Linear Regression - on all available variables
Multi_Reg=lm(price~area+bedrooms+bathrooms+stories+mainroad+guestroom+basement+hotwaterheating+airconditioning+parking+prefarea+furnishingstatus_num,data=housing_data_train)
print(summary(Multi_Reg))
AIC(Multi_Reg)

#Robust regression for multiple linear regression to assess effect of outliers on the model
Multi_Reg_rlm=rlm(price~area+bedrooms+bathrooms+stories+mainroad+guestroom+basement+hotwaterheating+airconditioning+parking+prefarea+furnishingstatus_num,data=housing_data_train, psi = psi.huber)    
print(summary(Multi_Reg_rlm))
AIC(Multi_Reg_rlm)
#AIC has increased showing that the robust regression model improved model by reducing effect of outliers
#However, we are still unable to assess the contribution of predictive power of the variable on the model due to scaling

#Correlation matrix 
#This is used to crosscheck if the normalization has affected the data
Corr_Matrix=cor(housing_data, method = "pearson")
print(Corr_Matrix)
# analysis of the correlation matrix only indicated 'hotwaterheating' and 'basement' as variables with the correlation of less than 20% 
# this has prompted analysis based on normalized data to remove the effect of different scales i.e., money, numbers, and binary data

# ------------------- LINEAR REGRESSION ANALYSIS USING NORMALIZED DATA -----------------------------------
#scaling the data to be on similar scale to understand the key influence in the model 
# Normalize data using base R
normalized_housing_data <- as.data.frame(lapply(housing_data, function(x) {
  if(is.numeric(x)) { # Apply only to numeric columns
    return((x - min(x, na.rm = TRUE)) / (max(x, na.rm = TRUE) - min(x, na.rm = TRUE)))
  } else {
    return(x)
  }
}))

#linear regression of price and area
plot(normalized_housing_data$area,normalized_housing_data$price,xlab="area",ylab="price",cex.lab=1.5,cex.axis=1.5,pch=16,col="blue")
Reg_1_1=lm(price~area,normalized_housing_data) 
print(summary(Reg_1_1))
# scaling has not impacted the relationship with the original data 
# R-square value on regression remains the same as well as the p-value indicating the predictive power is the same
# However, the weights have changed as they correspond to the scaled/normalized data and not the original data

#linear regression of price and bedrooms
plot(normalized_housing_data$bedrooms,normalized_housing_data$price,xlab="bedrooms",ylab="price",cex.lab=1.5,cex.axis=1.5,pch=16,col="blue")
Reg_2_1=lm(price~bedrooms,normalized_housing_data) 
print(summary(Reg_2_1))
#similar observation in bedrooms variable

#linear regression of price and bathrooms
plot(normalized_housing_data$bathrooms,normalized_housing_data$price,xlab="bathrooms",ylab="price",cex.lab=1.5,cex.axis=1.5,pch=16,col="blue")
Reg_3_1=lm(price~bathrooms,housing_data) 
print(summary(Reg_3_1))
#similar observation in bathroom variable

#linear regression of price and stories
plot(housing_data$stories,housing_data$price,xlab="area",ylab="area",cex.lab=1.5,cex.axis=1.5,pch=16,col="blue")
Reg_4=lm(price~stories,housing_data) 
print(summary(Reg_4))
#similar observation in stories variable

#linear regression of price and parking
plot(housing_data$parking,housing_data$price,xlab="area",ylab="area",cex.lab=1.5,cex.axis=1.5,pch=16,col="blue")
Reg_5=lm(price~parking,housing_data) 
print(summary(Reg_5))
#similar observation in parking variable

#Multiple Linear Regression -
Multi_Reg_1=lm(price~area+bedrooms+bathrooms+stories+mainroad+guestroom+basement+hotwaterheating+airconditioning+parking+prefarea+furnishingstatus_num,data=normalized_housing_data)
print(summary(Multi_Reg_1))
AIC(Multi_Reg_1)
#predictive power of the model has improved after scaling with all variables except bedrooms having statistical significance
#however, there are other variables such as mainroad, guestroom, basement,and furnishingstatus_num having a lower coefficient compared to bedrooms 

#Multiple Linear Regression -
Multi_Reg_3=rlm(price~area+bedrooms+bathrooms+stories+mainroad+guestroom+basement+hotwaterheating+airconditioning+parking+prefarea+furnishingstatus_num,data=normalized_housing_data, psi = psi.huber)
print(summary(Multi_Reg_3))
AIC(Multi_Reg_3)
#AIC has reduced in usage of robust linear regression indicating that outliers are not the cause and it may be the variables 

#Multiple Linear Regression without bedrooms
# Analysis to check the effect of removing mainroad, guestroom, basement,and furnishingstatus_num (i.e., variables with the least contribution to the model)
Multi_Reg_2=lm(price~area+bedrooms+bathrooms+stories+hotwaterheating+airconditioning+parking+prefarea,data=normalized_housing_data)
print(summary(Multi_Reg_2))
AIC(Multi_Reg_2)
#AIC and Adjusted R square has reduced indicating a reduction in predictive power 
#AIC is lower than robust linear regression, and Adjusted R square is less than the original full linear model

#Multiple Linear Regression -
Multi_Reg_4=lm(price~area+bathrooms+stories+mainroad+guestroom+basement+hotwaterheating+airconditioning+parking+prefarea+furnishingstatus_num,data=normalized_housing_data)
print(summary(Multi_Reg_4))
AIC(Multi_Reg_4)
#Best performing model is one without bathroom as all variables have significance greater than 0.05, and a relatively similar value of AIC and R-square 


#Reason for omitting bedrooms assessment through the Correlation matrix 
Corr_Matrix=cor(housing_data, method = "pearson")
print(Corr_Matrix)
#bedrooms has a higher correlation with bathrooms (~37%) and stories (~41%)
#It can be ommitted as compared to those two variables, it contributed the lowest to correlation with price 






