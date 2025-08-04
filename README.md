# Wine Quality Prediction using Linear Regression

This project uses physicochemical data to predict the quality ratings of white wines from the Quinta da Aveleda winery. The analysis focuses on building multiple linear regression models, with interaction and quadratic terms, to identify high-quality wines based on measurable chemical properties.

The work was conducted as part of a university-level statistics project.

---

## Project Summary

Researchers in the Vinho Verde region collected physicochemical data on over 4,800 white wines. The dataset includes 11 continuous numeric variables and a target quality score ranging from 1 to 7. 

The objective was to model wine quality using these features and select a subset of top-predicted wines that could be recommended for a professional wine showcase. The final regression model uses interaction and quadratic terms to improve predictive accuracy.

---

## Files Included

| File Name                     | Description                                                   |
|------------------------------|---------------------------------------------------------------|
| `wine_linearregression.R`  | R script with data processing, modeling, and evaluation logic |
| `winequality-white.csv`      | Original dataset downloaded from OpenML                       |
| `Random_Forest_Test_Pred.csv`| Random forest predictions (optional, for comparison)          |
| `Final Paper.docx`           | Final report describing the methodology and results           |
| `Final_Project_Slides.pptx`  | Presentation slides summarizing the project                   |

---

## Features Used

- Fixed Acidity  
- Volatile Acidity  
- Citric Acid  
- Residual Sugar  
- Chlorides  
- Free Sulfur Dioxide  
- Total Sulfur Dioxide  
- Density  
- pH  
- Sulphates  
- Alcohol  

---

## Modeling Techniques

- Multiple linear regression  
- Feature selection based on statistical significance  
- Variance Inflation Factor (VIF) analysis for multicollinearity  
- Interaction terms (e.g., alcohol × volatile acidity)  
- Quadratic transformations (e.g., alcohol²)  
- Log transformations (exploratory)  
- Decision tree model (for comparison purposes)  

---

## Results Summary

- Final Model: Linear regression with interaction and quadratic terms  
- Adjusted R²: 31.35%  
- Root Mean Squared Error (Test Set): 0.799  
- Most significant variables: Alcohol, Volatile Acidity, Fixed Acidity, Free Sulfur Dioxide  
- Final output includes a ranked prediction of the top 100 wines by predicted quality  

---

## How to Run the Analysis

1. Open the `wine_quality_regression.R` file in R or RStudio.  
2. Install the required packages (if not already installed):

   ```r
   install.packages(c("OpenML", "farff", "caTools", "tree", "car", "dplyr", "tidyverse", "psych"))
