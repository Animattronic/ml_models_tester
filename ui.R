library(shiny)
library(ggplot2)
library(e1071)


shinyUI(fluidPage(
  titlePanel("Iris data classification"),
  sidebarLayout(
    sidebarPanel(h2("Training controls"),
                 sliderInput("trainingDataPerc", "Training data percentage",
                             min=0.1, max=0.9, step=0.05, value = 0.8),
                 
                 radioButtons("normalizeData", label="Data normalization",
                              choices=list(
                                "Normalize features" = TRUE,
                                "Don't normalize features" = FALSE),
                              selected=TRUE),
                 
                 selectInput("trainingMethod", label="Training method",
                             choices=list(
                               "Support vector machines" = "svm",
                               "Random forest" = "rf",
                               "K-nearest neighbors" = "knn"),
                             selected="knn"),
                 
                 conditionalPanel(
                   condition="input.trainingMethod == 'svm'",
                   numericInput("tradeoffConstant", "SVM: Tradeoff constant", min = 1, max=99, value=1),
                   selectInput("kernelType", "SVM: Kernel type",
                               choices=list(
                                 "Radial basis" = "rbfdot",
                                 "Polynomial" = "polydot",
                                 "Linear" = "vanilladot",
                                 "Hyperbolic tangent" = "tanhdot",
                                 "Spline dot" = "splinedot")
                   )
                 ),
                 
                 conditionalPanel(
                   condition="input.trainingMethod == 'rf'",
                   numericInput("treesCount", "Random forest: trees count", min = 1, max=1000, value=200)
                 ),
                 
                 conditionalPanel(
                   condition="input.trainingMethod == 'knn'",
                   numericInput("neighborsCount", "Knn: neighbors count", min = 1, max=1000, value=200)
                 ),
                 
                 actionButton("trainModel", "Train model")
    ), # end sidebar panel
    mainPanel(
      tabsetPanel(
        tabPanel("Iris data",
                 dataTableOutput("irisData")
        ), # end tab panel 1
        tabPanel("Training results",
                 h3("Training confusion matrix (predicted/expected)"),
                 tableOutput("confusionMatrix"),
                 h3("Training results summary"),
                 tableOutput("predictionStats")
                 
        ), # end tab panel 2
        
        tabPanel("Help",
          h3("App purpose"),
          p("This applications allows you to test some basic Machine Learning models 
            (like SVM, KNN, Random Forest) on some toy example - classical Iris Data. You can
            play with different parameters and tune them to get the best results"),
          h3("Usage"),
          p("In the 'Iris data' panel you can see a data. You can inspect it visually/sort/subset, etc.
            Target variable/dependent variale is for this dataset the species of Iris flowers."),
          p("On the left panel you can find different configurtion options:"),
          
          h4("Training data percentage"),
          p("With this slider you can set the amount (%) of training data used to train the model"),
          
          h4("Data normalization"),
          p("With this option you can decide if you want to normalize all data columns to range 0-1. 
            Algorithms like SVM take benefit from such operation."),
          
          h4("Training method and parameters"),
          p("With this dropdown you can select algorithm you want. Additional configuration options will
            appear - depending on the specific algorithm. Once you are ready, hit the 'Train model' button"),
          
          h4("Training results tab"),
          p("This tab presents the training results. The first element is confusion matrix - showing
            the actual vs predcted values. You can inspect it visually to see which classes were better
            performing."),
          p("Below the confusion matrix, you can find the numerical classification quality measures, like
            accuracy, null hypothesis performance, etc. You can tune algorithms parameters to get better results."),
          p(""),
          p("Good luck!")
          
        ) # end tab panel 3
        
      ) # end tabset panel
      
      
    ) # end main panel
  )
))