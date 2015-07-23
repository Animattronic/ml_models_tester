library(shiny)
library(ggplot2)


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
                 
        ) # end tab panel 2
        
      ) # end tabset panel
      
      
    ) # end main panel
  )
))