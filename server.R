
library(shiny)
library(ggplot2)
library(randomForest)
library(kernlab)
library(caret)
library(class)

shinyServer(function(input, output) {
  
  output$irisData <- renderDataTable(iris)
  observeEvent(
    input$trainModel,{
      
      data <- iris
      if(input$normalizeData){
        normalized.data <- preProcess(iris[,-5], method=c("center", "scale"))
        data <- predict(normalized.data, iris[, -5])
        data["Species"] <- iris$Species
      }
      
      partitions <- createDataPartition(y = data$Species, list = FALSE, p = input$trainingDataPerc)
      training.data <- data[partitions, ]
      testing.data <- data[-partitions, ]
      
      model <- ""
      result <- ""
      
      if(input$trainingMethod == "svm"){
        norm.const <- input$tradeoffConstant
        model <- kernlab::ksvm(
          Species ~ .,
          data=training.data,
          kernel=input$kernelType,
          C=norm.const)
        result <- predict(model, testing.data)
        
      } else if(input$trainingMethod == "knn"){
        result <- class::knn(
          train=training.data[, -5],
          test=testing.data[, -5],
          cl=training.data$Species,
          k=input$neighborsCount)
        
      } else if(input$trainingMethod == "rf"){
        model <- randomForest(Species ~ ., data=training.data, ntree=input$treesCount)
        result <- predict(model, testing.data)
      }
      
      
      confMatrix <- caret::confusionMatrix(result, testing.data$Species)
      output$confusionMatrix <- renderTable(as.table(confMatrix$table))
      output$predictionStats <- renderTable(as.table(confMatrix$overall))
    })
})