library(shiny)
library(tidyverse)
library(DT)

# 1. DATA ENGINE: SIMULATION & ALGORITHM

generate_synthetic_cohort <- function(n = 1000) {
  set.seed(2026)
  
  tibble(
    Patient_ID = paste0("B2B-", 1000 + 1:n),
    Age_Over_35 = rbinom(n, 1, 0.22),
    Chronic_HTN = rbinom(n, 1, 0.14),
    History_of_Preeclampsia = rbinom(n, 1, 0.08)
  ) %>%
    mutate(
      prob_headache = case_when(
        Chronic_HTN == 1 & History_of_Preeclampsia == 1 ~ 0.45,
        Chronic_HTN == 1 | History_of_Preeclampsia == 1 ~ 0.25,
        TRUE ~ 0.04
      ),
      Severe_Headache = rbinom(n, 1, prob_headache),
      Fever = rbinom(n, 1, 0.05),
      Heavy_Bleeding = rbinom(n, 1, 0.06),
      Extreme_Anxiety = rbinom(n, 1, 0.11)
    ) %>%
    select(-prob_headache) %>%
    # Apply Point-Based Risk Scoring Algorithm
    mutate(
      Risk_Score = (Severe_Headache * 3) + 
        (Fever * 3) + 
        (Heavy_Bleeding * 3) + 
        (Extreme_Anxiety * 2) + 
        (Chronic_HTN * 1) + 
        (Age_Over_35 * 1) + 
        (History_of_Preeclampsia * 1),
      
      Triage_Tier = case_when(
        Risk_Score >= 4 | Severe_Headache == 1 | Fever == 1 | Heavy_Bleeding == 1 ~ "Red - Critical",
        Risk_Score >= 2 ~ "Yellow - Moderate",
        TRUE ~ "Green - Stable"
      ),
      
      Action_Protocol = case_when(
        Triage_Tier == "Red - Critical" ~ "TRIGGER EMS DISPATCH: Call patient immediately.",
        Triage_Tier == "Yellow - Moderate" ~ "NURSE TRIAGE: Schedule follow-up call within 2 hours.",
        TRUE ~ "MONITORING: Auto-logged. Proceed with standard daily cadence."
      )
    )
}

patient_data <- generate_synthetic_cohort(1000)

# 2. USER INTERFACE (UI)
ui <- fluidPage(
  titlePanel("BRIDGE-TO-BIRTH Surveillance Dashboard"),
  h5("Automated Postpartum Early Warning System (PEWS) Triage Engine", style = "color: gray;"),
  hr(),
  
  # KPI Metric Ribbon Section
  fluidRow(
    column(4, 
           div(style = "background-color: #f8f9fa; border-left: 5px solid #2980b9; padding: 15px; border-radius: 4px; box-shadow: 0 1px 3px rgba(0,0,0,0.1);",
               h3(textOutput("total_patients"), style = "margin:0; font-weight:700; color:#2980b9;"),
               p("Total Active Enrolled Patients", style = "margin:0; color:#7f8c8d; font-size:13px; font-weight:600;")
           )
    ),
    column(4, 
           div(style = "background-color: #fff5f5; border-left: 5px solid #c0392b; padding: 15px; border-radius: 4px; box-shadow: 0 1px 3px rgba(0,0,0,0.1);",
               h3(textOutput("red_flags"), style = "margin:0; font-weight:700; color:#c0392b;"),
               p("Critical Red Flags (Action Required)", style = "margin:0; color:#c0392b; font-size:13px; font-weight:600;")
           )
    ),
    column(4, 
           div(style = "background-color: #fffdf0; border-left: 5px solid #f39c12; padding: 15px; border-radius: 4px; box-shadow: 0 1px 3px rgba(0,0,0,0.1);",
               h3(textOutput("yellow_flags"), style = "margin:0; font-weight:700; color:#f39c12;"),
               p("Moderate Risk Queue Pending", style = "margin:0; color:#f39c12; font-size:13px; font-weight:600;")
           )
    )
  ),
  
  br(),
  hr(),
  
  sidebarLayout(
    sidebarPanel(
      width = 3,
      h4("Surveillance Filters"),
      br(),
      checkboxGroupInput(
        "tier_filter", 
        "Filter Triage Tiers:",
        choices = c("Red - Critical", "Yellow - Moderate", "Green - Stable"),
        selected = c("Red - Critical", "Yellow - Moderate")
      ),
      hr(),
      h5("Symptom Track Search:"),
      checkboxInput("show_headache", "Severe Headache", FALSE),
      checkboxInput("show_fever", "Fever Signs", FALSE),
      checkboxInput("show_bleeding", "Heavy Bleeding", FALSE)
    ),
    
    mainPanel(
      width = 9,
      h3("Active Surveillance Triage Queue"),
      DT::DTOutput("triage_table")
    )
  )
)

# 3. SERVER LOGIC
server <- function(input, output, session) {
  
  output$total_patients <- renderText({
    nrow(patient_data)
  })
  
  output$red_flags <- renderText({
    sum(patient_data$Triage_Tier == "Red - Critical")
  })
  
  output$yellow_flags <- renderText({
    sum(patient_data$Triage_Tier == "Yellow - Moderate")
  })
  
  filtered_data <- reactive({
    df <- patient_data
    
    if (!is.null(input$tier_filter)) {
      df <- df %>% filter(Triage_Tier %in% input$tier_filter)
    } else {
      df <- df %>% filter(FALSE)
    }
    
    if (input$show_headache) df <- df %>% filter(Severe_Headache == 1)
    if (input$show_fever)    df <- df %>% filter(Fever == 1)
    if (input$show_bleeding) df <- df %>% filter(Heavy_Bleeding == 1)
    
    df %>% select(Patient_ID, Risk_Score, Triage_Tier, Severe_Headache, Fever, Heavy_Bleeding, Extreme_Anxiety, Action_Protocol)
  })
  
  output$triage_table <- DT::renderDT({
    DT::datatable(
      filtered_data(),
      rownames = FALSE,
      options = list(
        pageLength = 10,
        autoWidth = TRUE,
        order = list(list(1, 'desc'))
      )
    )
  })
}

shinyApp(ui = ui, server = server)