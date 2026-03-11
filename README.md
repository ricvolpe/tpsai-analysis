# TPSai Analysis

Analysis code and reports for the development and validation of the Trust in Psychological Support from AI (TPSai) scale.

## Reports

| Report | Survey | Description |
|--------|--------|-------------|
| [Expert Evaluation]([Survey](https://ricvolpe.github.io/tpsai-analysis/docs/survey.pdf)) | [Survey]([Survey](https://ricvolpe.github.io/tpsai-analysis/surveys/TPSai_-_Experts.pdf) | Expert evaluation of item pool via inter-rater agreement |

## Reproducing the Analysis

1. Clone the repo
2. Open `tpsai-analysis.Rproj` in RStudio
3. Install dependencies:
```r
install.packages(c("tidyverse", "psych", "irr", "knitr"))
```
4. Render any `.qmd` file using the **Render** button in RStudio

## Dependencies

- R >= 4.0
- tidyverse
- irr
- psych
- knitr