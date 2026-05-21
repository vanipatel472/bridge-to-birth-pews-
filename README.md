# BRIDGE-TO-BIRTH: Postpartum Early Warning System (PEWS)
### Automated Surveillance Triage Pipeline for Reducing Severe Maternal Morbidity

## Clinical Challenge & Project Vision
Up to 80% of pregnancy-related deaths in the U.S. are entirely preventable, with a stark majority occurring during the late postpartum window (up to 1 year after delivery) due to a critical "delayed recognition gap" of high-urgency complications like preeclampsia, sepsis, and secondary hemorrhage. 

The **BRIDGE-TO-BIRTH** initiative translates static clinical safety protocols into an automated mobile text surveillance pipeline. This repository houses the operational point-based algorithmic risk layer, robust biostatistical cohort validation frameworks, and an interactive clinical triage dashboard designed to neutralize latency, catch adverse symptoms early, and optimize emergency medical workflows.

## Core Technical & Healthcare Analytics Competencies
* **Algorithmic Risk Layer:** Engineered an integer point-scoring heuristic derived from clinical emergency guidelines, dynamically stratifying multi-track symptom profiles into operational action tiers (Green, Yellow, Red).
* **Cohort Simulation Engine:** Formulated a synthetic data generation pipeline simulating 1,000 longitudinal patient profiles in R using conditional probability rules to model realistic correlations between medical history (e.g., chronic hypertension) and acute symptom onset.
* **Clinical Triage UI (R Shiny):** Developed a production-ready dashboard featuring real-time cohort telemetry cards, dynamic subset filtering, and automated clinical protocols to optimize nurse workflow tracking.
* **Biostatistical Stratification (R Markdown):** Generated fully reproducible epidemiologic baseline tables (`tableone`) and programmatic visuals evaluating symptom prevalence rates across stratified thresholds.

## Repository File Architecture
* `app.R` — The interactive, production-ready **BRIDGE-TO-BIRTH Triage Dashboard** built with native Shiny and DT components, featuring responsive top-level KPI metric cards.
* `simulation_pipeline.R` — Clean background R script executing the core probabilistic data generation engine and scoring logic.
* `BRIDGE-TO-BIRTH-_Postpartum_Surveillance_Analysis.Rmd` — Complete end-to-end reproducible research validation document detailing the statistical justification behind the chosen threshold boundaries.
* `BRIDGE-TO-BIRTH-_Postpartum_Surveillance_Analysis.html` — Fully rendered clinical data narrative report featuring compiled interactive charts and distribution visualizations.

---

## 👩‍💻 About the Author

**Vani Patel** is a Master’s student in **Biostatistics**, specializing in the intersection of data science, machine learning applications, and medical technology solutions. 

With an academic foundation combining **Bioinformatics and Economics** from the University of Waterloo alongside prior professional experience in **tech consulting**, her work focuses on leveraging large-scale health informatics, EHR analytics, and consumer wearable streams to remove processing latency from patient monitoring pipelines. 

