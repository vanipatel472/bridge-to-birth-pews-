library(tidyverse)

set.seed(2026)
n_patients <- 1000

cohort <- tibble(
  patient_id = 1:n_patients,
  age_over_35 = rbinom(n_patients, 1, 0.25), # 25% of cohort
  chronic_htn = rbinom(n_patients, 1, 0.15), # 15% of cohort
) %>%
  mutate(
    # Higher baseline risk increases the probability of reporting severe symptoms
    prob_headache = ifelse(chronic_htn == 1, 0.30, 0.05),
    severe_headache = rbinom(n_patients, 1, prob_headache),
    fever = rbinom(n_patients, 1, 0.04),
    heavy_bleeding = rbinom(n_patients, 1, 0.06),
    extreme_anxiety = rbinom(n_patients, 1, 0.12)
  ) %>%
  select(-prob_headache)


calculate_pews <- function(data) {
  data %>%
    mutate(
      score = (severe_headache * 3) + 
        (fever * 3) + 
        (heavy_bleeding * 3) + 
        (extreme_anxiety * 2) + 
        (chronic_htn * 1) + 
        (age_over_35 * 1),
      
      triage_tier = case_when(
        score >= 4 | severe_headache == 1 | fever == 1 | heavy_bleeding == 1 ~ "Red - Critical",
        score >= 2 ~ "Yellow - Moderate",
        TRUE ~ "Green - Stable"
      )
    )
}

scored_cohort <- calculate_pews(cohort)

