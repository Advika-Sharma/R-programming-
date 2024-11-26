### Summary: Creating and Deploying an R Model API Using Plumber

#### *Introduction to APIs*
APIs (Application Programming Interfaces) enable communication between software systems. One service sends a request, and the other processes it to return a result. Common API methods include:
- *POST*: For creating or sending data.
- *GET*: For retrieving data.
- *PUT*: For updating data.
- *DELETE*: For removing data.

APIs are structured around *endpoints, unique URLs for specific functionalities. These endpoints may require **parameters*, which are categorized as:
- *Required*: Essential for the API to function (e.g., inputs for predictions).
- *Optional*: Filters to refine or modify results.

#### *Training a Model in R*
To create a production-ready API, a classification model is trained using the Iris dataset. The *Random Forest* algorithm is used to predict the species of a flower based on sepal and petal dimensions. After training, the model is saved (save(model, file = "model.RData")) so it can be used in production without retraining. This step ensures efficiency and consistency in predictions.

#### *Building the API with Plumber*
The *Plumber* package in R allows for converting R scripts into APIs by adding structured annotations to define the API:
- @apiTitle specifies the API name.
- @param defines input parameters.
- @post or @get determines the HTTP method.
- Endpoint names (e.g., /clasificador) define specific API actions.

A function in the API takes the user-provided inputs (e.g., petal/sepal dimensions), processes them, and returns the prediction from the saved model. For example:
r
function(petal_length, petal_width, sepal_length, sepal_width) {
    load("model.RData")
    # Process inputs and predict species
    ...
    predict(model, test)
}

Plumber automatically generates an interactive user interface to test the API locally, enabling developers to validate its functionality.

#### *Deploying the API*
The API is packaged into a *Docker container* to ensure portability and compatibility across environments. A *Dockerfile* outlines the setup:
1. Install required R packages (e.g., randomForest).
2. Copy the saved model and API script into the container.
3. Configure the Plumber API to run on a specified port (e.g., 8080).

Using the *googleCloudRunner* R package, the Dockerized API is deployed to *Google Cloud Run*. This involves:
1. Uploading files (API script and Dockerfile) to *Google Cloud Storage*.
2. Building the Docker image in *Google Container Registry*.
3. Deploying the image to Cloud Run, which generates a public URL for the API.

#### *Testing and Usage*
The deployed API can be accessed via its unique URL. Developers can test the API with tools like *POST requests*. For example:
r
response <- POST("https://api-url/clasificador", 
                 body = list(sepal_length = 5.1, sepal_width = 3.5, 
                             petal_length = 1.4, petal_width = 0.2))

The API responds with the predicted flower species. This process ensures the API works as expected in real-world scenarios.

#### *Real-World Integration*
A practical application includes integrating the API with a web form. Users input flower dimensions in an HTML form, which sends a POST request to the API. The returned prediction is displayed to the user. This setup demonstrates the power of deploying machine learning models in production.

### *Conclusion*
By combining R, Plumber, Docker, and Google Cloud, this workflow illustrates how to train, package, deploy, and test an API for machine learning models. This approach enables seamless integration of predictive models into real-world applications, extending their utility beyond local analyses.
