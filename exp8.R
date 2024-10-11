# Load necessary libraries and check if they are installed
if (!require(randomForest)) {
  install.packages("randomForest", repos = "https://cloud.r-project.org")
  library(randomForest)
}

if (!require(caret)) {
  install.packages("caret", repos = "https://cloud.r-project.org")
  library(caret)
}

if (!require(ggplot2)) {
  install.packages("ggplot2", repos = "https://cloud.r-project.org")
  library(ggplot2)
}

# Load and check the dataset
file_path <- "D:\\R\\cleaned_data.csv"

# Error handling for file existence
if (file.exists(file_path)) {
  # Load the data
  health_data <- read.csv(file_path)
  print("Data loaded successfully!")
  
  # Display the structure of the dataset
  str(health_data)
  
  # Ensure necessary columns exist
  required_columns <- c("Data_Value", "Category", "TotalPopulation")
  
  if (all(required_columns %in% colnames(health_data))) {
    print("Required columns are present!")
    
    # Randomly split the data into training and testing sets (80% train, 20% test)
    set.seed(123)
    sample_index <- sample(1:nrow(health_data), 0.8 * nrow(health_data))
    
    train_data <- health_data[sample_index, ]
    test_data <- health_data[-sample_index, ]
    
    # Ensure there are no missing values
    train_data <- na.omit(train_data)
    test_data <- na.omit(test_data)
    
    # Train a Random Forest model
    random_forest_model <- randomForest(Data_Value ~ Category + TotalPopulation, data = train_data, ntree = 100)
    print("Random Forest model trained successfully!")
    
    # Predict on the test data
    predictions <- predict(random_forest_model, newdata = test_data)
    
    # Print model accuracy
    model_accuracy <- caret::postResample(pred = predictions, obs = test_data$Data_Value)
    print("Model accuracy (RMSE, Rsquared, MAE):")
    print(model_accuracy)
    
    # Create a data frame for plotting
    plot_data <- data.frame(Index = 1:length(predictions),
                            Actual = test_data$Data_Value,
                            Predicted = predictions)
    
    # Create a Line Plot for Actual and Predicted Values
    ggplot(plot_data, aes(x = Index)) +
      geom_line(aes(y = Actual, color = "Actual"), size = 1, alpha = 0.8) +
      geom_line(aes(y = Predicted, color = "Predicted"), size = 1, alpha = 0.8, linetype = "dashed") +
      labs(title = "Actual vs Predicted Values",
           x = "Index",
           y = "Values") +
      theme_minimal() +
      scale_color_manual(values = c("Actual" = "red", "Predicted" = "blue")) +
      theme(legend.title = element_blank(),
            plot.title = element_text(hjust = 0.5)) +
      geom_point(aes(y = Actual), color = "red", size = 1.5, alpha = 0.5) + 
      geom_point(aes(y = Predicted), color = "blue", size = 1.5, alpha = 0.5)  # Adding points for clarity
    
  } else {
    print("Required columns are missing from the dataset!")
  }
  
} else {
  print("File not found at the specified path!")
}

print(predictions)

