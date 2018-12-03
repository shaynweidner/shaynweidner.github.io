#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(MASS)
library(plotly)

# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("Correlated Joint Normal Distributions"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
     
       sidebarPanel(
         verticalLayout(
         numericInput(
           "samplesize",
           "Sample Size",
           value = 1000,
           min=10,
           max=10000,
           step=10
         ),
         numericInput(
           "Norm1Mean",
           "Mean of 1st Distribution",
           value = 0,
           step=1
         ),
         numericInput(
           "Norm2Mean",
           "Mean of 2nd Distribution",
           value = 0,
           step=1
         ),
         numericInput(
           "Norm1Var",
           "Variance of 1st Distribution",
           value = 1,
           min=0,
           step=1
         ),
         numericInput(
           "Norm2Var",
           "Variance of 2nd Distribution",
           value = 1,
           min=0,
           step=1
         ),
         numericInput(
           "MyCor",
           "Desired Correlation",
           value = .5,
           min=-1,
           max=1,
           step=.01
         ),
         numericInput(
           "MySeed",
           "Random Seed",
           value = 1234,
           min=0,
           step=1
         ),
         actionButton(
           inputId = "Submit",
           label = "Submit"
         )
       ,
       HTML(
         "<h3>Basic Instructions</h3><h4>1.Adjust any inputs above from their default values, as necessary<br>2.Hit 'Submit'<br>Interactive plot will appear to the right, after processing has completed (you may need to hover your mouse over it before it shows)<br><br>For more information, go to the app pitch <a href='https://shaynweidner.github.io/Final_Product_Pitch.html'>here</a></h4>"
         )
      )),
      
      # Show a plot of the generated distribution
      mainPanel(
        plotlyOutput("jointPlot"),
        textOutput("ActualCor")
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  SampleSize = eventReactive(input$Submit, {input$samplesize})
  Norm1Mean = eventReactive(input$Submit, {input$Norm1Mean})
  Norm2Mean = eventReactive(input$Submit, {input$Norm2Mean})
  Norm1Var = eventReactive(input$Submit, {input$Norm1Var})
  Norm2Var = eventReactive(input$Submit, {input$Norm2Var})
  MyCor = eventReactive(input$Submit, {input$MyCor})
  MySeed = eventReactive(input$Submit, {input$MySeed})
  MyCov = eventReactive(input$Submit, {MyCor() * sqrt(Norm1Var()) * sqrt(Norm2Var())})
  
  eventReactive(input$Submit, {set.seed(MySeed())})
  MyData = eventReactive(input$Submit, {as.data.frame(mvrnorm(n=SampleSize(),mu=c(Norm1Mean(),Norm2Mean()),Sigma = matrix(c(Norm1Var(),MyCov(),MyCov(),Norm2Var()),nrow=2)))})
  kd <- eventReactive(input$Submit, {kde2d((MyData())[,1], (MyData())[,2], n = round(5*log(SampleSize())))})
  #names(MyData)<-c("Norm1","Norm2")
  SampleCor <- eventReactive(input$Submit, {round(cor((MyData())[,1],(MyData())[,2]),3)})
  
  
  output$jointPlot <- renderPlotly({
    plot_ly(x = (kd())$x, y = (kd())$y, z = (kd())$z) %>% add_surface()
    }
  )
  
  output$ActualCor <- renderText({
    paste0("Actual sample correlation = ",SampleCor())
  })

  
  
}

# Run the application 
shinyApp(ui = ui, server = server)

