# Housing Price Analysis
## Project Overview
This project focuses on analyzing housing price data to uncover trends, patterns, and potential predictors of housing prices. Using R for data analysis and visualization, we aim to provide insights that could be valuable for investors, real estate companies, and individuals looking to buy or sell properties.

## Installation
To run the analysis, you will need to install certain R packages. Open R or RStudio and run the following commands:
install.packages("tidyverse")
install.packages("ggplot2")
install.packages("readr")
install.packages("dplyr")

## Dataset
The dataset for US housing prices was obtained from Kaggle. It contains house prices for 545 houses from several states in the US and 12 house-specific features. They include 'price' (indicating the sale price of the house), 'area' (total area of the property), 'bedrooms' (number of bedrooms), 'bathrooms' (number of bathrooms), 'stories' (number of floors in the house), and ‘parking' (number of parking spaces). Additionally, it includes nominal binary variables represented as 'yes' or 'no' for features such as 'mainroad' (whether the house is near a main road), 'guestroom' (whether there is a guest room), 'basement' (presence of a basement), 'hotwaterheating' (availability of hot water heating), and 'airconditioning' (presence of air conditioning). All data variables were transformed into numerical data to allow for inclusion in the linear regression model. The binary nominal variables represented as 'yes' or 'no' were encoded with ‘1’ and ‘0’ respectively. The 'furnishingstatus' variable was encoded with ‘3’ for furnished, ‘2’ for semi-furnished, and ‘1’ for unfurnished. ![image](https://github.com/derickkiwia/HousingPriceAnalysis/assets/134967257/5f8eed2a-2d83-4207-b1e6-87d9c28d067c)

## Analysis 
The methodology undertaken for this task was simple linear regression for each house-specific attribute and the target variable (i.e., Price) followed by the multilinear regression model. The initial simple linear regression aimed to assess if there was any form of linear relationship to develop a multilinear regression model that would be assessed on its ability to explain the variability in the model. 

## Results
The analysis reveals that excluding the number of bedrooms leads to the most accurate predictions of housing prices when using a robust regression model. This is likely because the influence of bedrooms is already captured by the related features of bathrooms (~37% correlation) and stories (~41% correlation). The key factors affecting housing prices are the size of the house, the number of bathrooms, and the number of stories, as evidenced by their significant coefficients in both the optimal multilinear regression using the least squares method and the robust regression using Huber's method on normalized data
