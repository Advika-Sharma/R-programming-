# Load necessary libraries and check if they are installed
if (!require(randomForest)) {
  install.packages("randomForest", repos = "https://cloud.r-project.org")
  library(randomForest)
}

if (!require(caret)) {
  install.packages("caret", repos = "https://cloud.r-project.org")
  library(caret)
}

# Load and check the dataset
file_path <- "D:\\R\\cleaned_data.csv"

# Error handling for file existence
if (file.exists(file_path)) {
  # Load the data
  health_data <- read.csv(file_path)
  print("Data loaded successfully!")
  
  # Display the first few rows and structure of the dataset
  print(head(health_data))
  str(health_data)
  
  # Ensure necessary columns exist
  required_columns <- c("Data_Value", "Category", "StateDesc", "Measure", "TotalPopulation")
  
  if (all(required_columns %in% colnames(health_data))) {
    print("Required columns are present!")
    
    # Randomly split the data into training and testing sets (70% train, 30% test)
    set.seed(123)
    sample_index <- sample(1:nrow(health_data), 0.7 * nrow(health_data))
    
    train_data <- health_data[sample_index, ]
    test_data <- health_data[-sample_index, ]
    
    # Ensure there are no missing values
    train_data <- na.omit(train_data)
    test_data <- na.omit(test_data)
    
    # Train a Random Forest model (adjust features and target as per your dataset)
    random_forest_model <- randomForest(Data_Value ~ Category + TotalPopulation, data = train_data, ntree = 100)
    print("Random Forest model trained successfully!")
    
    # Predict on the test data
    predictions <- predict(random_forest_model, newdata = test_data)
    
    # Print model accuracy
    model_accuracy <- caret::postResample(pred = predictions, obs = test_data$Data_Value)
    print("Model accuracy:")
    print(model_accuracy)
    
    # Visualize the importance of features
    importance(random_forest_model)
    varImpPlot(random_forest_model)
    
  } else {
    print("Required columns are missing from the dataset!")
  }
  
} else {
  print("File not found at the specified path!")
}

