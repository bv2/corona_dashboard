library(shiny)
library(tidyverse)

load("../../out/df_dt.RData")
load("../../out/df.RData")

shinyServer(function(input, output) {
  
  
  df_contrs <-  reactive({
    df <- filter(df, country %in% input$cntrs, date > input$start_date)
    if(input$ds100) {
      df$x = df$daysAfter100Cases 
      df <- filter(df, x >= 0)
      } else df$x = df$date
    df
    })

  xlab4plot <-   reactive({ifelse(input$ds100, "Days after 100 cases", "Date")})
  df_dt_contrs <-  reactive({
    df_dt <- filter(df_dt, country %in% input$cntrs, date > input$start_date)
    if(input$ds100) {
      df_dt$x = df_dt$date - df_dt$date0
      df_dt$x_closure = df_dt$date_closure - df_dt$date0
    } else {
      df_dt$x = df_dt$date
      df_dt$x_closure = df_dt$date_closure
    }
    df_dt
    })
  plotds100 <- reactive({input$ds100})
  plotlogscale <- reactive({input$logscale})
  
  
  output$cases <- renderPlot({
    # generate an rnorm distribution and plot it
    dftmp <- df_contrs()
    xlab4plottmp <- xlab4plot()
    gg <- dftmp %>% 
      ggplot(aes(x=x, y = Confirmed, col = country)) +
      geom_line() + ggtitle("Total cases") +xlab(xlab4plottmp) + theme_bw(base_size = 15)
    if(plotlogscale()) gg <- gg + scale_y_log10()
    gg
    
  })
  
  output$deaths <- renderPlot({
    # generate an rnorm distribution and plot it
    dftmp <- df_contrs()
    xlab4plottmp <- xlab4plot()
    gg <- dftmp %>% 
      ggplot(aes(x=x, y = Deaths, col = country)) +
      geom_line() + ggtitle("Total cases") +xlab(xlab4plottmp)+ theme_bw(base_size = 15)
    if(plotlogscale()) gg <- gg + scale_y_log10()
    gg
  })
  

  output$death_rate <- renderPlot({
    # generate an rnorm distribution and plot it
    dftmp <- df_contrs()
    xlab4plottmp <- xlab4plot()
    gg <- dftmp %>% 
      ggplot(aes(x=x, y = 100 * Deaths/Confirmed, col = country)) +
      geom_line()+  ylab("Death rate (%)") + xlab(xlab4plottmp)+ theme_bw(base_size = 15)
   gg
    
  })
  
  output$doubling_time <- renderPlot({
    # generate an rnorm distribution and plot it
    dftmp <- df_dt_contrs()
    xlab4plottmp <- xlab4plot()
    gg1 <- ggplot(dftmp, aes(x=x, y = doubling_time, col = country)) +
      geom_line() + ylab("doubling time (days)") +
      geom_vline(aes(xintercept = x_closure, col = country), lty = "dashed") +
      ggrepel::geom_text_repel(aes(x = x_closure, y= 5,
                                   label = ifelse(!is.na(date_closure) & date == date_closure,  country, ""))) +
      xlab(xlab4plottmp)+ theme_bw(base_size = 15)

   gg1
  })

  output$growth_rate <- renderPlot({
    # generate an rnorm distribution and plot it
    dftmp <- df_dt_contrs()
    xlab4plottmp <- xlab4plot()
    gg2 <- ggplot(dftmp, aes(x=x, y = growth_rate, col = country)) +
      geom_line() + ylab("Daily growth rate") +
      geom_vline(aes(xintercept = x_closure, col = country), lty = "dashed") +
      ggrepel::geom_text_repel(aes(x = x_closure, y= 2,
                                   label = ifelse(!is.na(date_closure) & date == date_closure,  country, ""))) +
      xlab(xlab4plottmp)+ theme_bw(base_size = 15)
    
    gg2
  })
  

})