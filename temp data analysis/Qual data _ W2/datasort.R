

library(readxl) # Read Excel xlsx file
library(openxlsx) # Write Excel files
library(tidyverse) # General package for cleaning and managing data (notably includes dplyr)
library(haven) # Read SPSS SAV file
library(sjlabelled) # Get and manipulate variable and value labels

rm(list=ls())

# Wave 2 - Repeaters data
raw_w2 <- read_sav("HWP_W2_data_clean_160322.sav")

d_w2 <- raw_w2 %>% 
  filter(IND_Repeater == 1 | IND_Open == 1) %>%
  mutate(
    White = ifelse(Ethnicity == 1, 1, 0)
  ) %>%
  select(IPAddress, RecordedDate, ResponseId, IND_Repeater, IND_Open, Age, Female, Ethnicity, White, Kids_10or16, Alone_di, 
         WA, HWSatis, HWCoor, HWDict, HWent, HW_satisf_break, 
         CH, CH_EFF, CH_PRESS, CH_PROM, CH_FLEX, CH_MEAN,
         ITQ_1, JS_1,
         HW_prefmet, prefmet_di, prefmet_cat, prefmet,
         WA_change_omi, WA_change_omi_3_TEXT, Counterfact_HWtext, Omicron, Thank_you)


d_w2 <- d_w2 %>% mutate(
  across(IND_Repeater: WA_change_omi , ~replace_na(.x, -99))
)
# across(everything(), fn)


d_w2_pros <- raw_w2 %>% 
  filter(IND_Repeater == 1 | IND_Open == 1) %>%
  select(IPAddress, ResponseId, Pro_home, Pro_office)



write.xlsx(d_w2,'HWP_data_w2_qual_raw.xlsx',rowNames = F)

write.xlsx(d_w2_pros,'HWP_data_w2_qual_PROS.xlsx',rowNames = F)


# -------------------------------------------------------------

IND_Repeater: from Repeater dataset
IND_Open: From Open Link data set
Female: Female 1, Male 0
Kids10or16: Kids in HH aged below 10, 11-15, or both.
Alone_di: Live alone (1/0)
HWSatis: Satisfaction with HW and the flexiblity
HWCoor: Coordinated HW
HWDict: HW dictated by others
HWent: Feeling entitled to HW
HW_satisf_break: Not being able to work flexibly would be a deal breaker for me
CH: CH factor
CH_EFF: Changes in effectiveness of working due to HWP
CH_PRESS: Changes in work pressures due to HWP
CH_PROM: Changes in how much company fulfils its promises due to HWP
CH_FLEX: Changes in flexibility due to HWP
CH_MEAN: Changes in meaningfulness due to HWP
HW_prefmet: plus=more than wanted in the office, 0=as much as wanted, minus=less than wanted in the office
prefmet_di: Preference met (1/0)
prefmet_cat: Preference met (cat)
WA_change_omi: Has the emergence of the new COVID-19 variant, Omicron, affected your working arrangement?
WA_change_omi_3_TEXT: Has the emergence of the new COVID-19 variant, Omicron, affected your working arrangement? Other, please specify.
Counterfact_HWtext: Is there anything you feel FTI Consulting could or should do differently with respect to hybrid working to help you improve your work situation?
Omicron: How has the emergence of the new COVID-19 variant, Omicron, affected you at work?
Thank you: Thank you for your participation. We appreciate your time and effort! Is there anything else you'd like to add?

