* Encoding: UTF-8.
*1. Quick analysis.

*Opening the data file.
GET 
  FILE='/Users/jerryluukkonen/Desktop/Hybrid Working survey folder/Data folder/Final folder/Hybrid Working survey (final: for checking data) 1 September.sav'. 
DATASET NAME HybridWorkingData WINDOW=FRONT.

*1. Frequencies.

*1.1. Number opening and consenting.
FREQUENCIES VARIABLES=intro_consent
  /ORDER=ANALYSIS.

*Excluding participants that did not consent.
FILTER OFF.
USE ALL.
SELECT IF (DistributionChannel = 'anonymous' AND survey <>-99 AND Counterfact_HWtext <>"test response" AND Thank_you <>"TEST" AND intro_consent = 1).
EXECUTE.

USE ALL.

*1.2. Number finishing the survey and number dropping out.

*Number finishing the survey.
FREQUENCIES VARIABLES=Consent_Future
  /ORDER=ANALYSIS.

*When they dropped out.
*1st question.
FREQUENCIES VARIABLES=CH_1
  /ORDER=ANALYSIS.

*5th question.
FREQUENCIES VARIABLES=InterJ_1
  /ORDER=ANALYSIS.

*7th question.
FREQUENCIES VARIABLES=HELP_1
  /ORDER=ANALYSIS.

*10th question.
FREQUENCIES VARIABLES=Eng_1
  /ORDER=ANALYSIS.

*14th question.
FREQUENCIES VARIABLES=LM_function
  /ORDER=ANALYSIS.

*1.3. Numbers by segment.
FREQUENCIES VARIABLES=Segment
  /ORDER=ANALYSIS.

*1.4. Numbers by location (country).
FREQUENCIES VARIABLES=location
  /ORDER=ANALYSIS.

*1.5. Time taken to complete the survey (for those that completed it).

*FILTER OFF.
*USE ALL.
*SELECT IF ((StartDate>=DATE.DMY(29,6,2021)) AND DistributionChannel = 'anonymous' AND survey <>"" AND Counterfact_HWtext <>"test response" AND Thank_you <>"TEST" AND intro_consent = 1 AND Consent_Future > 0).
*EXECUTE.

*USE ALL.

*DESCRIPTIVES Duration__in_seconds_.

*2. Descriptive statistics.

*2.1. Descriptive statistics before excluding responses.
FREQUENCIES VARIABLES=CH_1 CH_2 CH_3 CH_4 CH_5 CH_7 CH_8 CH_9 CH_10 CH_11 CH_12 CH_13 CH_14 CH_15 
    CH_16 CH_17 CH_18 CH_19 CH_21 HW_satisf Counterfact_HWtext HW_preference_1_1_1 HW_preference_2_1_1 
    HW_preference_3_1_1 HW_preference_4_1_1 HW_preference_5_1_1 HW_preference_5_1_TEXT 
    HW_preference_1_2_1 HW_preference_2_2_1 HW_preference_3_2_1 HW_preference_4_2_1 HW_preference_5_2_1 
    HW_preference_5_2_TEXT InterJ_1 InterJ_2 InterJ_3 InfoJ_1 InfoJ_2 InfoJ_3 InfoJ_4 InfoJ_5 ProcJ_1 
    ProcJ_2 ProcJ_3 ProcJ_4 ProcJ_5 ProcJ_6 DistrJ_1 DistrJ_2 DistrJ_3 DistrJ_4 HELP_1 HELP_2 HELP_3 
    PROMT_1 PROMT_2 PROMT_3 PROMC_1 PROMC_2 PROMC_3 PROMC_4 PROMR_1 PROMR_2 PROMR_3 TPROF_1 TPROF_2 
    TPROF_3 CWB_1 CWB_2 CWB_3 PREVT_1 PREVT_2 PREVT_3 PREVC_2 PREVC_3 PREVR_1 PREVR_2 PREVR_3 Eng_1 
    Eng_2 Eng_3 Eng_4 EXHAU_1 EXHAU_2 EXHAU_3 JS_1 OJ_1 OJ_2 OJ_3 PA_1 PA_2 PA_3 PA_4 PA_5 NA_1 NA_2 
    NA_3 NA_4 NA_5 drive drain WBMST_1 WBMST_2 WBMST_3 WBREL_1 WBREL_2 WBREL_3 Aut_1 Aut_2 Aut_3 
    Extra_1 Agree_1 Con_1 Neuro_1 Open_1 Extra_2 Agree_2 Con_2 Neuro_2 Open_2 Attention_1 LM_function 
    LM_interact LPSS_1 LPSS_2 LPSS_3 LPSS_4 LTRU_1 LTRU_2 LTRU_3 LTRU_4 LTRU_5 LOP_1 LOP_2 LOP_3 LOP_4 
    LCL_1 LCL_2 LCL_3 LCL_4 TM_interact TMLPS_1 TMLPS_2 TMLPS_3 TMLPS_4 TMTru_1 TMTru_2 TMTru_3 TMTru_4 
    TMTru_5 TMOP_1 TMOP_2 TMOP_3 TMOP_4 TMCL_1 TMCL_2 TMCL_3 TMCL_4 Location Segment Mgt_level Gender 
    Job_role Job_role_10_TEXT FT_PT FT_PT_2_TEXT Tenure Age Ethnicity workhours daysoff Consent_Future 
    Thank_you workhours_error workhours_corrected HW_preference_answered n_missing_total 
    proportion_missing response_variance drainR WBMST_1R WBREL_1R WBREL_3R Extra_1R Agree_2R Con_1R Neuro_1R 
    Open_1R LPSS_4R LTRU_3R LTRU_4R TMLPS_4R TMTru_3R TMTru_4R CH INTERJ INTERJ_2item INFOJ PROCJ 
    DISTRJ HELP PROMT PROMC PROMR TPROF CWB PREVT PREVC PREVT_PREVC PREVR ENG ENG_3item EXHAU OJ PA NA 
    DRIVE_DRAIN WBMST WBREL AUT EXTRAVERSION AGREEABLENESS CONSCIENTIOUSNESS NEUROTICISM OPENNESS LPSS 
    LPSS_3item LPSS_2item LTRU LOP LCL TMLPS TMLPS_3item TMTRU TMOP TMCL
  /STATISTICS=STDDEV MINIMUM MAXIMUM MEAN
  /ORDER=ANALYSIS.



*Excluding preview responses and responses from before the survey was launched (already excluded before).
*Excluding participants that did not consent.
*Excluding participants that missed the attention filter (with the exception of pilot responses).
*Excluding participants that completed an insufficient portion of the survey.
*Excluding participants with insufficient variance in responses.
FILTER OFF.
USE ALL.
SELECT IF ((DistributionChannel = 'anonymous') AND (survey <>-99) AND (Counterfact_HWtext <>"test response") AND (Thank_you <>"TEST") AND (intro_consent = 1) AND (Attention_1 >= 3)  AND (proportion_missing < 1) AND (response_variance > 0)).
EXECUTE.

USE ALL.


*2.2. Descriptive statistics after excluding responses.





*Saving as a new file (replace the destination folder with one you want to use).
SAVE OUTFILE='/Users/jerryluukkonen/Desktop/Hybrid Working survey folder/Data folder/Final folder/Hybrid Working survey (final: cleaned) 1 September.sav'.

DATASET CLOSE *.
