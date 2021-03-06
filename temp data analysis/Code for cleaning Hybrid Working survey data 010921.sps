* Encoding: UTF-8.
*Code for analysing Hybrid Working survey data.

*Keyboard shortcut for selecting entire code quickly: "command" + "a" if on a Mac and "ctrl" + "a" if on Windows

*1. Cleaning and and preparing data file for analysis.

*Opening the data file.
GET 
  FILE='/Users/jerryluukkonen/Desktop/Hybrid Working survey folder/Data folder/Final folder/Hybrid Working - response to communication - FINAL_August 31, 2021_10.49.sav'. 
DATASET NAME HybridWorkingData WINDOW=FRONT.

*Deleting superfluous variable for consent.
DELETE VARIABLES Status_C.
EXECUTE.

*Adding column titled suvey.
COMPUTE survey = -99.
IF (StartDate>=DATE.DMY(29,6,2021)) survey=2.
IF (ResponseId="R_2VpYWGypiOGF15Y" OR ResponseId="R_XnZgghN8mIZOi3L" OR ResponseId="R_3Elysdn8r9gFrvH" OR ResponseId="R_1QLYbR8ojF8XhF3"
     OR ResponseId="R_2AWPsYs9EsKSCfY" OR ResponseId="R_2zkdaBmWciZg00P" OR ResponseId="R_2e4k6JUcY8elack" OR ResponseId="R_1GfOcmDyyXsgg7v"
      OR ResponseId="R_1Nsuz1t0M4KTDfQ" OR ResponseId="R_vMRRDLtJg1U7oml" OR ResponseId="R_2U9pnRVZZ3xsSJL" OR ResponseId="R_7PNDX8WMzSrbuUh") survey=1.
EXECUTE.

*Moving the new column to be first in the file.
MATCH FILES
    FILE = *
    /KEEP = survey ALL.

*Excluding preview responses and test responses.
FILTER OFF.
USE ALL.
SELECT IF (DistributionChannel = 'anonymous' AND survey <>-99 AND Counterfact_HWtext <>"test response" AND Thank_you <>"TEST").
EXECUTE.

USE ALL.

*Checking workhour data.
FREQUENCIES VARIABLES=workhours
  /ORDER=ANALYSIS.

*Variable for noting possible errors in work hour data.
COMPUTE workhours_error = 0.
IF (FT_PT = 1 AND workhours > 100) workhours_error = 1.
IF (FT_PT = 2 AND workhours > FT_PT_2_TEXT * 1.5) workhours_error = 1.
EXECUTE.

*New variable for workhours correcting possible errors.
COMPUTE workhours_corrected = workhours.
IF (FT_PT = 1 AND workhours_error = 1) workhours_corrected = workhours/4.
IF (workhours > 400) workhours_corrected = -99.
EXECUTE.

*Fixing variable labels.
VARIABLE LABELS
survey "1 = pilot study and 2 = main study"
StartDate "Start Date"
EndDate "End Date"
Status "Response Type"
IPAddress "IP Address"
Progress "Progress"
Duration__in_seconds_ "Duration (in seconds)"
Finished "Finished"
RecordedDate "Recorded Date"
ResponseId "Response ID"
RecipientLastName "Recipient Last Name"
RecipientFirstName "Recipient First Name"
RecipientEmail "Recipient Email"
ExternalReference "External Data Reference"
LocationLatitude "Location Latitude"
LocationLongitude "Location Longitude"
DistributionChannel "Distribution Channel"
UserLanguage "User Language"
intro_consent "Consent"
CH_1 "How balanced your work-life relationship is"
CH_2 "How well you are able to switch off after work"
CH_3 "Your workload"
CH_4 "How much pressure you feel to be available at all times"
CH_5 "The quality of your performance"
CH_7 "How effectively you can work"
CH_8 "How distracted you get at work"
CH_9 "How well you are able to serve clients"
CH_10 "How much clarity you have about your work routines"
CH_11 "How much autonomy you have at work"
CH_12 "How flexibly you can arrange your time"
CH_13 "How well you can accommodate important non-work tasks into your schedule"
CH_14 "How meaningful your job feels"
CH_15 "Your sense of purpose at work"
CH_16 "How connected you feel to others at work"
CH_17 "How well you collaborate within and across your team"
CH_18 "How much your company (or its representatives) meets your expectations"
CH_19 "How much your company fulfills its promises to its employees"
CH_21 "Your sense of belonging at work"
HW_satisf "Overall, to what extent do you think the new hybrid working principles are a good thing?"
Counterfact_HWtext "Is there anything you feel Andersch could or should do differently with respect to hybrid working to help you improve your work situation?"
HW_preference_1_1_1 "Work from home most or all of the time"
HW_preference_2_1_1 "Go to the office (or be on site) all or most of the time"
HW_preference_3_1_1 "Go to the office at least 2 times a week and work from home at least 2 times a week"
HW_preference_4_1_1 "No fixed schedule but flexible as need arises"
HW_preference_5_1_1 "Other, please specify"
HW_preference_5_1_TEXT "Other, please specify"
HW_preference_1_2_1 "Work from home most or all of the time"
HW_preference_2_2_1 "Go to the office (or be on site) all or most of the time"
HW_preference_3_2_1 "Go to the office at least 2 times a week and work from home at least 2 times a week"
HW_preference_4_2_1 "No fixed schedule but flexible as need arises"
HW_preference_5_2_1 "Other, please specify"
HW_preference_5_2_TEXT "Other, please specify"
InterJ_1 "Treat me in a polite manner"
InterJ_2 "Treat me with respect"
InterJ_3 "Refrain from improper remarks or comments"
InfoJ_1 "Communicate with me in a candid manner"
InfoJ_2 "Explain processes related to the hybrid working principles thoroughly"
InfoJ_3 "Explain processes related to the hybrid working principles in a reasonable way"
InfoJ_4 "Communicate information regarding the new hybrid working principles in a timely manner"
InfoJ_5 "Tailor communication related to the hybrid working principles to meet my needs"
ProcJ_1 "Ask my views and feelings about the hybrid working principles"
ProcJ_2 "Give me influence over the outcome of the hybrid working principles"
ProcJ_3 "Apply procedures related to the hybrid working principles consistently"
ProcJ_4 "Ensure procedures related to the hybrid working principles are free of bias"
ProcJ_5 "Base procedures related to the hybrid working principles on accurate information"
ProcJ_6 "Uphold ethical and moral standards when implementing the hybrid working principles"
DistrJ_1 "reflect the effort you put into your work?"
DistrJ_2 "reflect what you contribute to the company?"
DistrJ_3 "are justified, given your performance?"
DistrJ_4 "are appropriate for the work you have completed?"
HELP_1 "I helped others who had work-related problems"
HELP_2 "I helped co-workers make progress on their work"
HELP_3 "I helped co-workers avoid potential problems with their work"
PROMT_1 "I actively took on more tasks in my work"
PROMT_2 "I added complexity to my tasks by changing their structure or sequence"
PROMT_3 "I increased the frequency of difficult decisions I made in my work"
PROMC_1 "I tried to think of my job as a whole, rather than as separate tasks"
PROMC_2 "I thought about how my job contributed to the organization’s goals"
PROMC_3 "I thought about new ways of viewing my overall job"
PROMC_4 "I thought about ways in which my job as a whole contributed to society"
PROMR_1 "I made efforts to get to know other people at work better."
PROMR_2 "I sought to interact with other people at work, regardless of how well I knew them."
PROMR_3 "I tried to spend more time with a wide variety of people at work."
TPROF_1 "carried out the core parts of my job well"
TPROF_2 "completed my core tasks well using the standard procedures"
TPROF_3 "ensured my tasks were completed properly"
CWB_1 "not worked to the best of my ability"
CWB_2 "spent time on tasks unrelated to work during working hours"
CWB_3 "taken unnecessary breaks"
PREVT_1 "I actively reduced the scope of tasks I worked on"
PREVT_2 "I tried to simplify some of the tasks that I worked on"
PREVT_3 "I sought to make some of my work mentally less intense"
PREVC_2 "I assessed the different elements of my job to determine which parts were most meaningful"
PREVC_3 "I tried to think of my job as a set of separate tasks, rather than as a ‘whole’"
PREVR_1 "I minimized my interactions with people at work that I did not get along with"
PREVR_2 "I changed my work so that I only interacted with people that I felt good about working with"
PREVR_3 "I tried to avoid situations at work where I had to meet new people"
Eng_1 "I was full of energy in my work"
Eng_2 "I felt enthusiastic about my work"
Eng_3 "I was inspired by my job"
Eng_4 "I was completely immersed in my work"
EXHAU_1 "I felt emotionally drained from my work"
EXHAU_2 "I felt used up at the end of the work day"
EXHAU_3 "I dreaded getting up in the morning and having to face another day of work"
JS_1 "I have been satisfied with my present job"
OJ_1 "Overall, I was treated fairly by my organisation"
OJ_2 "In general, the treatment I received around here was fair"
OJ_3 "In general, I could count on my organisation to be fair"
PA_1 "Active"
PA_2 "Determined"
PA_3 "Attentive"
PA_4 "Inspired"
PA_5 "Alert"
NA_1 "Afraid"
NA_2 "Nervous"
NA_3 "Upset"
NA_4 "Hostile"
NA_5 "Ashamed"
drive "Energized"
drain "Drained"
WBMST_1 "The demands of everyday work got me down"
WBMST_2 "I felt I was in charge of the situation in which I work"
WBMST_3 "I was good at managing the responsibilities of daily working life"
WBREL_1 "Maintaining working relationships was difficult and frustrating for me"
WBREL_2 "I enjoyed personal and mutual conversations at work"
WBREL_3 "I have not experienced many warm and trusting relationships with others at work"
Aut_1 "The job gave me a chance to use my personal initiative or judgment in carrying out the work"
Aut_2 "I was able to choose the way to go about my job"
Aut_3 "The job provided me with significant autonomy in making decisions or carrying out the work"
Extra_1 "is reserved"
Agree_1 "is generally trusting"
Con_1 "tends to be lazy"
Neuro_1 "is relaxed, handles stress well"
Open_1 "has few artistic interests"
Extra_2 "is outgoing, sociable"
Agree_2 "tends to find fault with others"
Con_2 "does a thorough job"
Neuro_2 "gets nervous easily"
Open_2 "has an active imagination"
Attention_1 "has paid great attention to the questions in this survey"
LM_function "Are you currently a line manager (or project lead) at your company?"
LM_interact "In the past month, how often have you had the opportunity to interact with the members of the team that you supervise?"
LPSS_1 "asked my team members' opinions"
LPSS_2 "inquired about the wellbeing of my team members"
LPSS_3 "provided help to my team members when they had a problem"
LPSS_4 "not responded to my team member for a while"
LTRU_1 "trusted my team members to perform their tasks independently"
LTRU_2 "been open and upfront with my team members"
LTRU_3 "not always made all team members feel trusted"
LTRU_4 "not always been honest and truthful with all team members"
LTRU_5 "felt my team members' motives and intentions were good"
LOP_1 "allowed different ways of accomplishing a task"
LOP_2 "encouraged experimentation with different ideas"
LOP_3 "given possibilities for independent thinking and acting"
LOP_4 "given room for their own ideas"
LCL_1 "monitored and controlled goal attainment"
LCL_2 "established routines"
LCL_3 "controlled adherence to guidelines and rules"
LCL_4 "paid attention to task accomplishment according to set standards"
TM_interact "Over the past month, how often have you had the opportunity to interact with your line manager or coach?"
TMLPS_1 "asked me or team members' opinions"
TMLPS_2 "inquired about me or team members' wellbeing"
TMLPS_3 "provided help to me or team members when they had a problem"
TMLPS_4 "not responded to me or team member for a while"
TMTru_1 "trusted me or team members to perform tasks independently"
TMTru_2 "been open and upfront with me or team members"
TMTru_3 "not always made me or team members' feel trusted"
TMTru_4 "not always been honest and truthful with me or team members"
TMTru_5 "believed our motives and intentions were good"
TMOP_1 "allowed different ways of accomplishing a task"
TMOP_2 "encouraged experimentation with different ideas"
TMOP_3 "given possibilities for independent thinking and acting"
TMOP_4 "given room for my own ideas"
TMCL_1 "monitored and controlled goal attainment"
TMCL_2 "established routines"
TMCL_3 "controlled adherence to guidelines and rules"
TMCL_4 "paid attention to task accomplishment according to set standards"
Location "In which location do you mainly work?"
Segment "In which segment of FTI Consulting do you work?"
Mgt_level "Which level best applies to you?"
Gender "You are:"
Job_role "Which of the below best describes your job? - Selected Choice"
Job_role_10_TEXT "Other, please specify - Text"
FT_PT "Do you work at FTI consulting? - Selected Choice"
FT_PT_2_TEXT "Part-time? If so, how many hours a week? - Text"
Tenure "How many years have you worked for FTI Consulting?"
Age "How old are you?"
Ethnicity "How would you describe your ethnicity?"
workhours "How many hours a week have you worked on average over the past month (including overtime)?"
daysoff "In the past 4 weeks, how many days have you not worked at all (count weekend, days off, and annual leave/holidays)?"
Consent_Future "Are you happy to participate in the follow-up surveys?"
Thank_you "Thank you for your participation. We appreciate your time and effort!"
workhours_error "Noting possible errors with workhour data"
workhours_corrected "Attempt at correcting workhour data".

VALUE LABELS
                  /survey
                                     1 "Pilot study"
                                     2 "Main study"
	/Status
		0 "IP Address"
		1 "Survey Preview"
		2 "Survey Test"
		4 "Imported"
		8 "Spam"
		9 "Survey Preview Spam"
		12 "Imported Spam"
		16 "Offline"
		17 "Offline Survey Preview"
		32 "EX"
		40 "EX Spam"
		48 "EX Offline"
	/Finished
		0 "False"
		1 "True"
	/intro_consent
		1 "I have read the above and consent to take part in this study"
		2 "I do not wish to participate and do not want to be contacted again"
	/CH_1
		1 "Much worsened"
		2 "Worsened"
		3 "Neither/nor"
		4 "Improved"
		5 "Much improved"
	/CH_2
		1 "Much worsened"
		2 "Worsened"
		3 "Neither/nor"
		4 "Improved"
		5 "Much improved"
	/CH_3
		1 "Much worsened"
		2 "Worsened"
		3 "Neither/nor"
		4 "Improved"
		5 "Much improved"
	/CH_4
		1 "Much worsened"
		2 "Worsened"
		3 "Neither/nor"
		4 "Improved"
		5 "Much improved"
	/CH_5
		1 "Much worsened"
		2 "Worsened"
		3 "Neither/nor"
		4 "Improved"
		5 "Much improved"
	/CH_7
		1 "Much worsened"
		2 "Worsened"
		3 "Neither/nor"
		4 "Improved"
		5 "Much improved"
	/CH_8
		1 "Much worsened"
		2 "Worsened"
		3 "Neither/nor"
		4 "Improved"
		5 "Much improved"
	/CH_9
		1 "Much worsened"
		2 "Worsened"
		3 "Neither/nor"
		4 "Improved"
		5 "Much improved"
	/CH_10
		1 "Much worsened"
		2 "Worsened"
		3 "Neither/nor"
		4 "Improved"
		5 "Much improved"
	/CH_11
		1 "Much worsened"
		2 "Worsened"
		3 "Neither/nor"
		4 "Improved"
		5 "Much improved"
	/CH_12
		1 "Much worsened"
		2 "Worsened"
		3 "Neither/nor"
		4 "Improved"
		5 "Much improved"
	/CH_13
		1 "Much worsened"
		2 "Worsened"
		3 "Neither/nor"
		4 "Improved"
		5 "Much improved"
	/CH_14
		1 "Much worsened"
		2 "Worsened"
		3 "Neither/nor"
		4 "Improved"
		5 "Much improved"
	/CH_15
		1 "Much worsened"
		2 "Worsened"
		3 "Neither/nor"
		4 "Improved"
		5 "Much improved"
	/CH_16
		1 "Much worsened"
		2 "Worsened"
		3 "Neither/nor"
		4 "Improved"
		5 "Much improved"
	/CH_17
		1 "Much worsened"
		2 "Worsened"
		3 "Neither/nor"
		4 "Improved"
		5 "Much improved"
	/CH_18
		1 "Much worsened"
		2 "Worsened"
		3 "Neither/nor"
		4 "Improved"
		5 "Much improved"
	/CH_19
		1 "Much worsened"
		2 "Worsened"
		3 "Neither/nor"
		4 "Improved"
		5 "Much improved"
	/CH_21
		1 "Much worsened"
		2 "Worsened"
		3 "Neither/nor"
		4 "Improved"
		5 "Much improved"
	/HW_satisf
		1 "Not at all"
		2 "To a small extent"
		3 "To a moderate extent"
		4 "To a large extent"
		5 "To a very large extent"
		6 "I don't know enough about them to have an opinion"
	/HW_preference_1_1_1
		1 "HW_pref"
	/HW_preference_2_1_1
		1 "HW_pref"
	/HW_preference_3_1_1
		1 "HW_pref"
	/HW_preference_4_1_1
		1 "HW_pref"
	/HW_preference_5_1_1
		1 "HW_pref"
	/HW_preference_1_2_1
		1 "HW_prac"
	/HW_preference_2_2_1
		1 "HW_prac"
	/HW_preference_3_2_1
		1 "HW_prac"
	/HW_preference_4_2_1
		1 "HW_prac"
	/HW_preference_5_2_1
		1 "HW_prac"
	/InterJ_1
		1 "Hardly ever"
		2 "Rarely"
		3 "Sometimes"
		4 "Often"
		5 "Very often"
	/InterJ_2
		1 "Hardly ever"
		2 "Rarely"
		3 "Sometimes"
		4 "Often"
		5 "Very often"
	/InterJ_3
		1 "Hardly ever"
		2 "Rarely"
		3 "Sometimes"
		4 "Often"
		5 "Very often"
	/InfoJ_1
		1 "Hardly ever"
		2 "Rarely"
		3 "Sometimes"
		4 "Often"
		5 "Very often"
	/InfoJ_2
		1 "Hardly ever"
		2 "Rarely"
		3 "Sometimes"
		4 "Often"
		5 "Very often"
	/InfoJ_3
		1 "Hardly ever"
		2 "Rarely"
		3 "Sometimes"
		4 "Often"
		5 "Very often"
	/InfoJ_4
		1 "Hardly ever"
		2 "Rarely"
		3 "Sometimes"
		4 "Often"
		5 "Very often"
	/InfoJ_5
		1 "Hardly ever"
		2 "Rarely"
		3 "Sometimes"
		4 "Often"
		5 "Very often"
	/ProcJ_1
		1 "Hardly ever"
		2 "Rarely"
		3 "Sometimes"
		4 "Often"
		5 "Very often"
	/ProcJ_2
		1 "Hardly ever"
		2 "Rarely"
		3 "Sometimes"
		4 "Often"
		5 "Very often"
	/ProcJ_3
		1 "Hardly ever"
		2 "Rarely"
		3 "Sometimes"
		4 "Often"
		5 "Very often"
	/ProcJ_4
		1 "Hardly ever"
		2 "Rarely"
		3 "Sometimes"
		4 "Often"
		5 "Very often"
	/ProcJ_5
		1 "Hardly ever"
		2 "Rarely"
		3 "Sometimes"
		4 "Often"
		5 "Very often"
	/ProcJ_6
		1 "Hardly ever"
		2 "Rarely"
		3 "Sometimes"
		4 "Often"
		5 "Very often"
	/DistrJ_1
		1 "Hardly ever"
		2 "Rarely"
		3 "Sometimes"
		4 "Often"
		5 "Very often"
	/DistrJ_2
		1 "Hardly ever"
		2 "Rarely"
		3 "Sometimes"
		4 "Often"
		5 "Very often"
	/DistrJ_3
		1 "Hardly ever"
		2 "Rarely"
		3 "Sometimes"
		4 "Often"
		5 "Very often"
	/DistrJ_4
		1 "Hardly ever"
		2 "Rarely"
		3 "Sometimes"
		4 "Often"
		5 "Very often"
	/HELP_1
		1 "Hardly ever"
		2 "Rarely"
		3 "Sometimes"
		4 "Often"
		5 "Very often"
	/HELP_2
		1 "Hardly ever"
		2 "Rarely"
		3 "Sometimes"
		4 "Often"
		5 "Very often"
	/HELP_3
		1 "Hardly ever"
		2 "Rarely"
		3 "Sometimes"
		4 "Often"
		5 "Very often"
	/PROMT_1
		1 "Hardly ever"
		2 "Rarely"
		3 "Sometimes"
		4 "Often"
		5 "Very often"
	/PROMT_2
		1 "Hardly ever"
		2 "Rarely"
		3 "Sometimes"
		4 "Often"
		5 "Very often"
	/PROMT_3
		1 "Hardly ever"
		2 "Rarely"
		3 "Sometimes"
		4 "Often"
		5 "Very often"
	/PROMC_1
		1 "Hardly ever"
		2 "Rarely"
		3 "Sometimes"
		4 "Often"
		5 "Very often"
	/PROMC_2
		1 "Hardly ever"
		2 "Rarely"
		3 "Sometimes"
		4 "Often"
		5 "Very often"
	/PROMC_3
		1 "Hardly ever"
		2 "Rarely"
		3 "Sometimes"
		4 "Often"
		5 "Very often"
	/PROMC_4
		1 "Hardly ever"
		2 "Rarely"
		3 "Sometimes"
		4 "Often"
		5 "Very often"
	/PROMR_1
		1 "Hardly ever"
		2 "Rarely"
		3 "Sometimes"
		4 "Often"
		5 "Very often"
	/PROMR_2
		1 "Hardly ever"
		2 "Rarely"
		3 "Sometimes"
		4 "Often"
		5 "Very often"
	/PROMR_3
		1 "Hardly ever"
		2 "Rarely"
		3 "Sometimes"
		4 "Often"
		5 "Very often"
	/TPROF_1
		1 "Hardly ever"
		2 "Rarely"
		3 "Sometimes"
		4 "Often"
		5 "Very often"
	/TPROF_2
		1 "Hardly ever"
		2 "Rarely"
		3 "Sometimes"
		4 "Often"
		5 "Very often"
	/TPROF_3
		1 "Hardly ever"
		2 "Rarely"
		3 "Sometimes"
		4 "Often"
		5 "Very often"
	/CWB_1
		1 "Hardly ever"
		2 "Rarely"
		3 "Sometimes"
		4 "Often"
		5 "Very often"
	/CWB_2
		1 "Hardly ever"
		2 "Rarely"
		3 "Sometimes"
		4 "Often"
		5 "Very often"
	/CWB_3
		1 "Hardly ever"
		2 "Rarely"
		3 "Sometimes"
		4 "Often"
		5 "Very often"
	/PREVT_1
		1 "Hardly ever"
		2 "Rarely"
		3 "Sometimes"
		4 "Often"
		5 "Very often"
	/PREVT_2
		1 "Hardly ever"
		2 "Rarely"
		3 "Sometimes"
		4 "Often"
		5 "Very often"
	/PREVT_3
		1 "Hardly ever"
		2 "Rarely"
		3 "Sometimes"
		4 "Often"
		5 "Very often"
	/PREVC_2
		1 "Hardly ever"
		2 "Rarely"
		3 "Sometimes"
		4 "Often"
		5 "Very often"
	/PREVC_3
		1 "Hardly ever"
		2 "Rarely"
		3 "Sometimes"
		4 "Often"
		5 "Very often"
	/PREVR_1
		1 "Hardly ever"
		2 "Rarely"
		3 "Sometimes"
		4 "Often"
		5 "Very often"
	/PREVR_2
		1 "Hardly ever"
		2 "Rarely"
		3 "Sometimes"
		4 "Often"
		5 "Very often"
	/PREVR_3
		1 "Hardly ever"
		2 "Rarely"
		3 "Sometimes"
		4 "Often"
		5 "Very often"
	/Eng_1
		1 "Hardly ever"
		2 "Rarely"
		3 "Sometimes"
		4 "Often"
		5 "Very often"
	/Eng_2
		1 "Hardly ever"
		2 "Rarely"
		3 "Sometimes"
		4 "Often"
		5 "Very often"
	/Eng_3
		1 "Hardly ever"
		2 "Rarely"
		3 "Sometimes"
		4 "Often"
		5 "Very often"
	/Eng_4
		1 "Hardly ever"
		2 "Rarely"
		3 "Sometimes"
		4 "Often"
		5 "Very often"
	/EXHAU_1
		1 "Hardly ever"
		2 "Rarely"
		3 "Sometimes"
		4 "Often"
		5 "Very often"
	/EXHAU_2
		1 "Hardly ever"
		2 "Rarely"
		3 "Sometimes"
		4 "Often"
		5 "Very often"
	/EXHAU_3
		1 "Hardly ever"
		2 "Rarely"
		3 "Sometimes"
		4 "Often"
		5 "Very often"
	/JS_1
		1 "Hardly ever"
		2 "Rarely"
		3 "Sometimes"
		4 "Often"
		5 "Very often"
	/OJ_1
		1 "Hardly ever"
		2 "Rarely"
		3 "Sometimes"
		4 "Often"
		5 "Very often"
	/OJ_2
		1 "Hardly ever"
		2 "Rarely"
		3 "Sometimes"
		4 "Often"
		5 "Very often"
	/OJ_3
		1 "Hardly ever"
		2 "Rarely"
		3 "Sometimes"
		4 "Often"
		5 "Very often"
	/PA_1
		1 "Hardly ever"
		2 "Rarely"
		3 "Sometimes"
		4 "Often"
		5 "Very often"
	/PA_2
		1 "Hardly ever"
		2 "Rarely"
		3 "Sometimes"
		4 "Often"
		5 "Very often"
	/PA_3
		1 "Hardly ever"
		2 "Rarely"
		3 "Sometimes"
		4 "Often"
		5 "Very often"
	/PA_4
		1 "Hardly ever"
		2 "Rarely"
		3 "Sometimes"
		4 "Often"
		5 "Very often"
	/PA_5
		1 "Hardly ever"
		2 "Rarely"
		3 "Sometimes"
		4 "Often"
		5 "Very often"
	/NA_1
		1 "Hardly ever"
		2 "Rarely"
		3 "Sometimes"
		4 "Often"
		5 "Very often"
	/NA_2
		1 "Hardly ever"
		2 "Rarely"
		3 "Sometimes"
		4 "Often"
		5 "Very often"
	/NA_3
		1 "Hardly ever"
		2 "Rarely"
		3 "Sometimes"
		4 "Often"
		5 "Very often"
	/NA_4
		1 "Hardly ever"
		2 "Rarely"
		3 "Sometimes"
		4 "Often"
		5 "Very often"
	/NA_5
		1 "Hardly ever"
		2 "Rarely"
		3 "Sometimes"
		4 "Often"
		5 "Very often"
	/drive
		1 "Hardly ever"
		2 "Rarely"
		3 "Sometimes"
		4 "Often"
		5 "Very often"
	/drain
		1 "Hardly ever"
		2 "Rarely"
		3 "Sometimes"
		4 "Often"
		5 "Very often"
	/WBMST_1
		1 "Hardly ever"
		2 "Rarely"
		3 "Sometimes"
		4 "Often"
		5 "Very often"
	/WBMST_2
		1 "Hardly ever"
		2 "Rarely"
		3 "Sometimes"
		4 "Often"
		5 "Very often"
	/WBMST_3
		1 "Hardly ever"
		2 "Rarely"
		3 "Sometimes"
		4 "Often"
		5 "Very often"
	/WBREL_1
		1 "Hardly ever"
		2 "Rarely"
		3 "Sometimes"
		4 "Often"
		5 "Very often"
	/WBREL_2
		1 "Hardly ever"
		2 "Rarely"
		3 "Sometimes"
		4 "Often"
		5 "Very often"
	/WBREL_3
		1 "Hardly ever"
		2 "Rarely"
		3 "Sometimes"
		4 "Often"
		5 "Very often"
	/Aut_1
		1 "Hardly ever"
		2 "Rarely"
		3 "Sometimes"
		4 "Often"
		5 "Very often"
	/Aut_2
		1 "Hardly ever"
		2 "Rarely"
		3 "Sometimes"
		4 "Often"
		5 "Very often"
	/Aut_3
		1 "Hardly ever"
		2 "Rarely"
		3 "Sometimes"
		4 "Often"
		5 "Very often"
	/Extra_1
		1 "Strongly disagree"
		2 "Disagree"
		3 "Neither agree nor disagree"
		4 "Agree"
		5 "Strongly agree"
	/Agree_1
		1 "Strongly disagree"
		2 "Disagree"
		3 "Neither agree nor disagree"
		4 "Agree"
		5 "Strongly agree"
	/Con_1
		1 "Strongly disagree"
		2 "Disagree"
		3 "Neither agree nor disagree"
		4 "Agree"
		5 "Strongly agree"
	/Neuro_1
		1 "Strongly disagree"
		2 "Disagree"
		3 "Neither agree nor disagree"
		4 "Agree"
		5 "Strongly agree"
	/Open_1
		1 "Strongly disagree"
		2 "Disagree"
		3 "Neither agree nor disagree"
		4 "Agree"
		5 "Strongly agree"
	/Extra_2
		1 "Strongly disagree"
		2 "Disagree"
		3 "Neither agree nor disagree"
		4 "Agree"
		5 "Strongly agree"
	/Agree_2
		1 "Strongly disagree"
		2 "Disagree"
		3 "Neither agree nor disagree"
		4 "Agree"
		5 "Strongly agree"
	/Con_2
		1 "Strongly disagree"
		2 "Disagree"
		3 "Neither agree nor disagree"
		4 "Agree"
		5 "Strongly agree"
	/Neuro_2
		1 "Strongly disagree"
		2 "Disagree"
		3 "Neither agree nor disagree"
		4 "Agree"
		5 "Strongly agree"
	/Open_2
		1 "Strongly disagree"
		2 "Disagree"
		3 "Neither agree nor disagree"
		4 "Agree"
		5 "Strongly agree"
	/Attention_1
		1 "Strongly disagree"
		2 "Disagree"
		3 "Neither agree nor disagree"
		4 "Agree"
		5 "Strongly agree"
	/LM_function
		1 "Yes"
		2 "No"
	/LM_interact
		1 "Hardly ever"
		2 "Rarely"
		3 "Sometimes"
		4 "Often"
		5 "Very often"
	/LPSS_1
		1 "Hardly ever"
		2 "Rarely"
		3 "Sometimes"
		4 "Often"
		5 "Very often"
	/LPSS_2
		1 "Hardly ever"
		2 "Rarely"
		3 "Sometimes"
		4 "Often"
		5 "Very often"
	/LPSS_3
		1 "Hardly ever"
		2 "Rarely"
		3 "Sometimes"
		4 "Often"
		5 "Very often"
	/LPSS_4
		1 "Hardly ever"
		2 "Rarely"
		3 "Sometimes"
		4 "Often"
		5 "Very often"
	/LTRU_1
		1 "Hardly ever"
		2 "Rarely"
		3 "Sometimes"
		4 "Often"
		5 "Very often"
	/LTRU_2
		1 "Hardly ever"
		2 "Rarely"
		3 "Sometimes"
		4 "Often"
		5 "Very often"
	/LTRU_3
		1 "Hardly ever"
		2 "Rarely"
		3 "Sometimes"
		4 "Often"
		5 "Very often"
	/LTRU_4
		1 "Hardly ever"
		2 "Rarely"
		3 "Sometimes"
		4 "Often"
		5 "Very often"
	/LTRU_5
		1 "Hardly ever"
		2 "Rarely"
		3 "Sometimes"
		4 "Often"
		5 "Very often"
	/LOP_1
		1 "Hardly ever"
		2 "Rarely"
		3 "Occasionally"
		4 "Often"
		5 "Very often"
	/LOP_2
		1 "Hardly ever"
		2 "Rarely"
		3 "Occasionally"
		4 "Often"
		5 "Very often"
	/LOP_3
		1 "Hardly ever"
		2 "Rarely"
		3 "Occasionally"
		4 "Often"
		5 "Very often"
	/LOP_4
		1 "Hardly ever"
		2 "Rarely"
		3 "Occasionally"
		4 "Often"
		5 "Very often"
	/LCL_1
		1 "Hardly ever"
		2 "Rarely"
		3 "Occasionally"
		4 "Often"
		5 "Very often"
	/LCL_2
		1 "Hardly ever"
		2 "Rarely"
		3 "Occasionally"
		4 "Often"
		5 "Very often"
	/LCL_3
		1 "Hardly ever"
		2 "Rarely"
		3 "Occasionally"
		4 "Often"
		5 "Very often"
	/LCL_4
		1 "Hardly ever"
		2 "Rarely"
		3 "Occasionally"
		4 "Often"
		5 "Very often"
	/TM_interact
		1 "Hardly ever"
		2 "Rarely"
		3 "Sometimes"
		4 "Often"
		5 "Very often"
	/TMLPS_1
		1 "Hardly ever"
		2 "Rarely"
		3 "Occasionally"
		4 "Often"
		5 "Very often"
	/TMLPS_2
		1 "Hardly ever"
		2 "Rarely"
		3 "Occasionally"
		4 "Often"
		5 "Very often"
	/TMLPS_3
		1 "Hardly ever"
		2 "Rarely"
		3 "Occasionally"
		4 "Often"
		5 "Very often"
	/TMLPS_4
		1 "Hardly ever"
		2 "Rarely"
		3 "Occasionally"
		4 "Often"
		5 "Very often"
	/TMTru_1
		1 "Hardly ever"
		2 "Rarely"
		3 "Occasionally"
		4 "Often"
		5 "Very often"
	/TMTru_2
		1 "Hardly ever"
		2 "Rarely"
		3 "Occasionally"
		4 "Often"
		5 "Very often"
	/TMTru_3
		1 "Hardly ever"
		2 "Rarely"
		3 "Occasionally"
		4 "Often"
		5 "Very often"
	/TMTru_4
		1 "Hardly ever"
		2 "Rarely"
		3 "Occasionally"
		4 "Often"
		5 "Very often"
	/TMTru_5
		1 "Hardly ever"
		2 "Rarely"
		3 "Occasionally"
		4 "Often"
		5 "Very often"
	/TMOP_1
		1 "Hardly ever"
		2 "Rarely"
		3 "Occasionally"
		4 "Often"
		5 "Very often"
	/TMOP_2
		1 "Hardly ever"
		2 "Rarely"
		3 "Occasionally"
		4 "Often"
		5 "Very often"
	/TMOP_3
		1 "Hardly ever"
		2 "Rarely"
		3 "Occasionally"
		4 "Often"
		5 "Very often"
	/TMOP_4
		1 "Hardly ever"
		2 "Rarely"
		3 "Occasionally"
		4 "Often"
		5 "Very often"
	/TMCL_1
		1 "Hardly ever"
		2 "Rarely"
		3 "Occasionally"
		4 "Often"
		5 "Very often"
	/TMCL_2
		1 "Hardly ever"
		2 "Rarely"
		3 "Occasionally"
		4 "Often"
		5 "Very often"
	/TMCL_3
		1 "Hardly ever"
		2 "Rarely"
		3 "Occasionally"
		4 "Often"
		5 "Very often"
	/TMCL_4
		1 "Hardly ever"
		2 "Rarely"
		3 "Occasionally"
		4 "Often"
		5 "Very often"
	/Location
		1 "United Kingdom"
		2 "Ireland"
		3 "Belgium"
		4 "France"
		5 "Germany"
		6 "Spain"
		7 "United Arab Emirates - Dubai (DIFC)"
		8 "United Arab Emirates - Dubai (Port Saeed)"
		9 "United Arab Emirates - Abu Dhabi"
		10 "Qatar"
		11 "South Africa"
	/Segment
		1 "Corporate"
		2 "Corporate Finance"
		3 "Economic & Financial Consulting"
		4 "Forensic & Litigation Consulting"
		5 "Strategic Communication"
		6 "Technology"
	/Mgt_level
		1 "Level 1 (Associate, Consultant or equivalent)"
		2 "Level 2 (Senior Consultant or equivalent)"
		3 "Level 3 (Director or equivalent)"
		4 "Level 4 (Senior Director or equivalent)"
		5 "Level 5 or level 6 (Managing Director or equivalent; Senior Managing Director)"
	/Gender
		1 "Female"
		2 "Male"
		3 "Non binary"
		4 "Other"
		5 "Prefer not to say"
	/Job_role
		1 "Billable job role"
		2 "Administrative Support"
		4 "Finance"
		5 "IT"
		6 "Legal"
		7 "HR"
		8 "Marketing"
		9 "Real Estate and Facilities"
		10 "Other, please specify"
	/FT_PT
		1 "Full-time?"
		2 "Part-time? If so, how many hours a week?"
	/Tenure
		1 "Less than a year"
		2 "1 year"
		3 "2 years"
		4 "3 years"
		5 "4 years"
		6 "5 years"
		7 "6 years"
		8 "7 years"
		9 "8 years"
		10 "9 years"
		11 "10 years"
		12 "11 years"
		13 "12 years"
		14 "13 years"
		15 "14 years"
		16 "15 years"
		17 "16 years"
		18 "17 years"
		19 "18 years"
		20 "19 years"
		21 "20 years"
		22 "More than 20 years"
	/Age
		1 "18"
		2 "19"
		3 "20"
		4 "21"
		5 "22"
		6 "23"
		7 "24"
		8 "25"
		9 "26"
		10 "27"
		11 "28"
		12 "29"
		13 "30"
		14 "31"
		15 "32"
		16 "33"
		17 "34"
		18 "35"
		19 "36"
		20 "37"
		21 "38"
		22 "39"
		23 "40"
		24 "41"
		25 "42"
		26 "43"
		27 "44"
		28 "45"
		29 "46"
		30 "47"
		31 "48"
		32 "49"
		33 "50"
		34 "51"
		35 "52"
		36 "53"
		37 "54"
		38 "55"
		39 "56"
		40 "57"
		41 "58"
		42 "59"
		43 "60"
		44 "61"
		45 "62"
		46 "63"
		47 "64"
		48 "65"
		49 "66"
		50 "67"
		51 "68"
		52 "69"
		53 "70"
		54 "71"
		55 "72"
		56 "73"
		57 "74"
		58 "75"
		59 "76"
		60 "77"
		61 "78"
		62 "79"
		63 "80"
		64 "81"
		65 "82"
		66 "83"
		67 "84"
		68 "85"
		69 "86"
		70 "87"
		71 "88"
		72 "89"
		73 "90"
	/Ethnicity
		1 "White"
		2 "East Asian (e.g. Chinese, Japanese, Korean)"
		3 "South Asian (e.g. Pakistani, Indian)"
		4 "Other Asian background"
		5 "African"
		6 "Caribbean"
		7 "Other Black background"
		8 "Arab"
		9 "Mixed background"
		10 "Other ethnic group"
		11 "Prefer not to say"
	/Consent_Future
		1 "Yes, I am happy to be contacted again for the follow-up research"
		2 "No, don't contact me again"
                  /workhours_error
                                     1 "Possible error"
                                     0 "No error"                                     
.
CACHE.
EXECUTE.

*Recoding missing values as -99.
RECODE CH_1 CH_2 CH_3 CH_4 CH_5 CH_7 CH_8 CH_9 CH_10 CH_11 CH_12 CH_13 CH_14 CH_15 CH_16 CH_17 CH_18 CH_19 CH_21
      HW_satisf
      HW_preference_1_1_1 HW_preference_2_1_1 HW_preference_3_1_1 HW_preference_4_1_1 HW_preference_5_1_1 
      HW_preference_1_2_1 HW_preference_2_2_1 HW_preference_3_2_1 HW_preference_4_2_1 HW_preference_5_2_1
      InterJ_1 InterJ_2 InterJ_3
      InfoJ_1 InfoJ_2 InfoJ_3 InfoJ_4 InfoJ_5
      ProcJ_1 ProcJ_2 ProcJ_3 ProcJ_4 ProcJ_5 ProcJ_6
      DistrJ_1 DistrJ_2 DistrJ_3 DistrJ_4
      HELP_1 HELP_2 HELP_3
      PROMT_1 PROMT_2 PROMT_3
      PROMC_1 PROMC_2 PROMC_3 PROMC_4
      PROMR_1 PROMR_2 PROMR_3
      TPROF_1 TPROF_2 TPROF_3
      CWB_1 CWB_2 CWB_3
      PREVT_1 PREVT_2 PREVT_3
      PREVC_2 PREVC_3
      PREVR_1 PREVR_2 PREVR_3
      Eng_1 Eng_2 Eng_3 Eng_4
      EXHAU_1 EXHAU_2 EXHAU_3
      JS_1
      OJ_1 OJ_2 OJ_3
      PA_1 PA_2 PA_3 PA_4 PA_5
      NA_1 NA_2 NA_3 NA_4 NA_5
      drive drain
      WBMST_1 WBMST_2 WBMST_3
      WBREL_1 WBREL_2 WBREL_3
      Aut_1 Aut_2 Aut_3
      Extra_1 Agree_1 Con_1 Neuro_1 Open_1 Extra_2 Agree_2 Con_2 Neuro_2 Open_2
      Attention_1
      LM_function
      Location Segment Mgt_level Gender Job_role FT_PT FT_PT_2_TEXT Tenure Age Ethnicity workhours daysoff
      Consent_Future 
      workhours_corrected (SYSMIS=-99).
IF (Counterfact_HWtext ="") Counterfact_HWtext = "-99".
IF (HW_preference_5_1_TEXT ="") HW_preference_5_1_TEXT = "-99".
IF (HW_preference_5_2_TEXT ="") HW_preference_5_2_TEXT = "-99".
IF (Job_role_10_TEXT="") Job_role_10_TEXT= "-99".
EXECUTE.

DO IF (LM_function = 1 OR LM_function = -99). 
    RECODE LM_interact  
    LPSS_1 LPSS_2 LPSS_3 LPSS_4 
    LTRU_1 LTRU_2 LTRU_3 LTRU_4 LTRU_5 
    LOP_1 LOP_2 LOP_3 LOP_4 
    LCL_1 LCL_2 LCL_3 LCL_4 (SYSMIS=-99).
END IF.
EXECUTE.

DO IF (LM_function = 2 OR LM_function = -99).
    RECODE TM_interact
    TMLPS_1 TMLPS_2 TMLPS_3 TMLPS_4
    TMTru_1 TMTru_2 TMTru_3 TMTru_4 TMTru_5
    TMOP_1 TMOP_2 TMOP_3 TMOP_4
    TMCL_1 TMCL_2 TMCL_3 TMCL_4 (SYSMIS=-99).
END IF.
EXECUTE.

*Recoding missing values for non applicable questions as -1.
DO IF (LM_function = 1).
    RECODE TM_interact
        TMLPS_1 TMLPS_2 TMLPS_3 TMLPS_4
        TMTru_1 TMTru_2 TMTru_3 TMTru_4 TMTru_5
        TMOP_1 TMOP_2 TMOP_3 TMOP_4
        TMCL_1 TMCL_2 TMCL_3 TMCL_4 (SYSMIS=-1).
END IF.
EXECUTE.

DO IF (LM_function = 2). 
    RECODE LM_interact  
        LPSS_1 LPSS_2 LPSS_3 LPSS_4 
        LTRU_1 LTRU_2 LTRU_3 LTRU_4 LTRU_5 
        LOP_1 LOP_2 LOP_3 LOP_4 
        LCL_1 LCL_2 LCL_3 LCL_4 (SYSMIS=-1).
END IF.
EXECUTE.

COMPUTE HW_preference_answered = 0.
IF (HW_preference_1_1_1 > 0 OR HW_preference_2_1_1 > 0 OR HW_preference_3_1_1 > 0 OR HW_preference_4_1_1 > 0 OR HW_preference_5_1_1 > 0 OR 
    HW_preference_1_2_1 > 0 OR HW_preference_2_2_1 > 0 OR HW_preference_3_2_1 > 0 OR HW_preference_4_2_1 > 0 OR HW_preference_5_2_1 > 0)
    HW_preference_answered = 1.
EXECUTE.

VARIABLE LABELS HW_preference_answered "Was the HW_preference question answered?".
EXECUTE.

VALUE LABELS HW_preference_answered
    1 "Answered"
    0 "Not answered".
EXECUTE.

FREQUENCIES VARIABLES=HW_preference_answered
  /ORDER=ANALYSIS.

*Counting number of questions left unanswered.
COUNT n_missing = CH_1 CH_2 CH_3 CH_4 CH_5 CH_7 CH_8 CH_9 CH_10 CH_11 CH_12 CH_13 CH_14 CH_15 CH_16 CH_17 CH_18 CH_19 CH_21
      HW_satisf
      HW_preference_answered
      InterJ_1 InterJ_2 InterJ_3
      InfoJ_1 InfoJ_2 InfoJ_3 InfoJ_4 InfoJ_5
      ProcJ_1 ProcJ_2 ProcJ_3 ProcJ_4 ProcJ_5 ProcJ_6
      DistrJ_1 DistrJ_2 DistrJ_3 DistrJ_4
      HELP_1 HELP_2 HELP_3
      PROMT_1 PROMT_2 PROMT_3
      PROMC_1 PROMC_2 PROMC_3 PROMC_4
      PROMR_1 PROMR_2 PROMR_3
      TPROF_1 TPROF_2 TPROF_3
      CWB_1 CWB_2 CWB_3
      PREVT_1 PREVT_2 PREVT_3
      PREVC_2 PREVC_3
      PREVR_1 PREVR_2 PREVR_3
      Eng_1 Eng_2 Eng_3 Eng_4
      EXHAU_1 EXHAU_2 EXHAU_3
      JS_1
      OJ_1 OJ_2 OJ_3
      PA_1 PA_2 PA_3 PA_4 PA_5
      NA_1 NA_2 NA_3 NA_4 NA_5
      drive drain
      WBMST_1 WBMST_2 WBMST_3
      WBREL_1 WBREL_2 WBREL_3
      Aut_1 Aut_2 Aut_3
      Extra_1 Agree_1 Con_1 Neuro_1 Open_1 Extra_2 Agree_2 Con_2 Neuro_2 Open_2
      Attention_1
      LM_function
      Location Segment Mgt_level Gender Job_role FT_PT Tenure Age Ethnicity workhours daysoff
      Consent_Future (-99).
IF (Counterfact_HWtext = '-99') n_missing = n_missing + 1.
EXECUTE.

*Counting missed LM questions.
COMPUTE n_missing_LM = 0.
DO IF (LM_function = 1).
    COUNT n_missing_LM = LM_interact  
        LPSS_1 LPSS_2 LPSS_3 LPSS_4 
        LTRU_1 LTRU_2 LTRU_3 LTRU_4 LTRU_5 
        LOP_1 LOP_2 LOP_3 LOP_4 
        LCL_1 LCL_2 LCL_3 LCL_4 (-99).
END IF.
EXECUTE.

*Counting missing TM questions.
COMPUTE n_missing_TM = 0.
DO IF (LM_function = 2).
    COUNT n_missing_TM = TM_interact
        TMLPS_1 TMLPS_2 TMLPS_3 TMLPS_4
        TMTru_1 TMTru_2 TMTru_3 TMTru_4 TMTru_5
        TMOP_1 TMOP_2 TMOP_3 TMOP_4
        TMCL_1 TMCL_2 TMCL_3 TMCL_4 (-99).
END IF.
EXECUTE.

*Counting missing questions if the LM_function question was not answered.
IF (LM_function = -99) n_missing = n_missing + 18.
EXECUTE.

*Adding all missing values together.
COMPUTE n_missing_total = n_missing +n_missing_LM + n_missing_TM.
EXECUTE.

VARIABLE LABELS n_missing_total "How many questions were not answered?".
EXECUTE.

*Deleting unneeded variables.
DELETE VARIABLES n_missing n_missing_LM n_missing_TM.
EXECUTE.

*Calculating proportion of questions left unanswered.
COMPUTE proportion_missing = n_missing_total/141.
EXECUTE.

VARIABLE LABELS proportion_missing "What proportion of questions were not answered?".
EXECUTE.

*Calculating variance in answers (used for removing removing responses with very little variance (straight-lining).
COMPUTE response_variance1 = 0.
DO IF (LM_function = 1).
    COMPUTE response_variance1=VARIANCE(CH_1 to HW_satisf, InterJ_1 to LM_function, LM_interact to LCL_4).
END IF.
EXECUTE.

COMPUTE response_variance2 = 0.
DO IF (LM_function = 2).
    COMPUTE response_variance2=VARIANCE(CH_1 to HW_satisf, InterJ_1 to LM_function, TM_interact to TMCL_4).
END IF.
EXECUTE.

COMPUTE response_variance = response_variance1 + response_variance2.
VARIABLE LABELS response_variance 'Response variance'.
EXECUTE.

DELETE VARIABLES response_variance1 response_variance2.

*pilot responses counted as having passed the attention filter (it was only added after the pilot).
IF (survey=1) Attention_1 = 5.
EXECUTE.

*Recoding items into different variables in preparation for computing factors.
RECODE drain (1 = 5) (2 = 4) (3 = 3) (4 = 2) (5 = 1) INTO drainR.
VARIABLE LABELS drainR "Drained (R)".
VALUE LABELS drainR
1 "Very often"
2 "Often"
3 "Sometimes"
4 "Rarely"
5 "Hardly ever".
EXECUTE.

RECODE WBMST_1 (1 = 5) (2 = 4) (3 = 3) (4 = 2) (5 = 1) INTO WBMST_1R.
VARIABLE LABELS WBMST_1R "The demands of everyday work got me down (R)".
VALUE LABELS WBMST_1R
1 "Very often"
2 "Often"
3 "Sometimes"
4 "Rarely"
5 "Hardly ever".
EXECUTE.

RECODE WBREL_1 (1 = 5) (2 = 4) (3 = 3) (4 = 2) (5 = 1) INTO WBREL_1R.
VARIABLE LABELS WBREL_1R "Maintaining working relationships was difficult and frustrating for me (R)".
VALUE LABELS WBREL_1R
1 "Very often"
2 "Often"
3 "Sometimes"
4 "Rarely"
5 "Hardly ever".
EXECUTE.

RECODE WBREL_3 (1 = 5) (2 = 4) (3 = 3) (4 = 2) (5 = 1) INTO WBREL_3R.
VARIABLE LABELS WBREL_3R "I have not experienced many warm and trusting relationships with others at work (R)".
VALUE LABELS WBREL_3R
1 "Very often"
2 "Often"
3 "Sometimes"
4 "Rarely"
5 "Hardly ever".
EXECUTE.

RECODE Extra_1 (1 = 5) (2 = 4) (3 = 3) (4 = 2) (5 = 1) INTO Extra_1R.
VARIABLE LABELS Extra_1R "is reserved (R)".
VALUE LABELS Extra_1R
1 "Strongly agree"
2 "Agree"
3 "Neither agree nor disagree"
4 "Disagree"
5 "Strongly disagree".
EXECUTE.

RECODE Agree_2 (1 = 5) (2 = 4) (3 = 3) (4 = 2) (5 = 1) INTO Agree_2R.
VARIABLE LABELS Agree_2R "tends to find fault with others (R)".
VALUE LABELS Agree_2R
1 "Strongly agree"
2 "Agree"
3 "Neither agree nor disagree"
4 "Disagree"
5 "Strongly disagree".
EXECUTE.

RECODE Con_1 (1 = 5) (2 = 4) (3 = 3) (4 = 2) (5 = 1) INTO Con_1R.
VARIABLE LABELS Con_1R "tends to be lazy (R)".
VALUE LABELS Con_1R
1 "Strongly agree"
2 "Agree"
3 "Neither agree nor disagree"
4 "Disagree"
5 "Strongly disagree".
EXECUTE.

RECODE Neuro_1 (1 = 5) (2 = 4) (3 = 3) (4 = 2) (5 = 1) INTO Neuro_1R.
VARIABLE LABELS Neuro_1R "is relaxed, handles stress well (R)".
VALUE LABELS Neuro_1R
1 "Strongly agree"
2 "Agree"
3 "Neither agree nor disagree"
4 "Disagree"
5 "Strongly disagree".
EXECUTE.

RECODE Open_1 (1 = 5) (2 = 4) (3 = 3) (4 = 2) (5 = 1) INTO Open_1R.
VARIABLE LABELS Open_1R "has few artistic interests (R)".
VALUE LABELS Open_1R
1 "Strongly agree"
2 "Agree"
3 "Neither agree nor disagree"
4 "Disagree"
5 "Strongly disagree".
EXECUTE.

RECODE LPSS_4 (1 = 5) (2 = 4) (3 = 3) (4 = 2) (5 = 1) INTO LPSS_4R.
VARIABLE LABELS LPSS_4R "not responded to my team member for a while (R)".
VALUE LABELS LPSS_4R
1 "Very often"
2 "Often"
3 "Sometimes"
4 "Rarely"
5 "Hardly ever".
EXECUTE.

RECODE LTRU_3 (1 = 5) (2 = 4) (3 = 3) (4 = 2) (5 = 1) INTO LTRU_3R.
VARIABLE LABELS LTRU_3R "not always made all team members feel trusted (R)".
VALUE LABELS LTRU_3R
1 "Very often"
2 "Often"
3 "Sometimes"
4 "Rarely"
5 "Hardly ever".
EXECUTE.

RECODE LTRU_4 (1 = 5) (2 = 4) (3 = 3) (4 = 2) (5 = 1) INTO LTRU_4R.
VARIABLE LABELS LTRU_4R "not always been honest and truthful with all team members (R)".
VALUE LABELS LTRU_4R
1 "Very often"
2 "Often"
3 "Sometimes"
4 "Rarely"
5 "Hardly ever".
EXECUTE.

RECODE TMLPS_4 (1 = 5) (2 = 4) (3 = 3) (4 = 2) (5 = 1) INTO TMLPS_4R.
VARIABLE LABELS TMLPS_4R "not responded to me or team member for a while (R)".
VALUE LABELS TMLPS_4R
1 "Very often"
2 "Often"
3 "Occasionally"
4 "Rarely"
5 "Hardly ever".
EXECUTE.

RECODE TMTru_3 (1 = 5) (2 = 4) (3 = 3) (4 = 2) (5 = 1) INTO TMTru_3R.
VARIABLE LABELS TMTru_3R "not always made me or team members' feel trusted (R)".
VALUE LABELS TMTru_3R
1 "Very often"
2 "Often"
3 "Occasionally"
4 "Rarely"
5 "Hardly ever".
EXECUTE.
    
RECODE TMTru_4 (1 = 5) (2 = 4) (3 = 3) (4 = 2) (5 = 1) INTO TMTru_4R.
VARIABLE LABELS TMTru_4R "not always been honest and truthful with me or team members (R)".
VALUE LABELS TMTru_4R
1 "Very often"
2 "Often"
3 "Occasionally"
4 "Rarely"
5 "Hardly ever".
EXECUTE.

RECODE drainR WBMST_1R WBREL_1R WBREL_3R Extra_1R Agree_2R Con_1R Neuro_1R Open_1R 
    LPSS_4R LTRU_3R LTRU_4R TMLPS_4R TMTru_3R, TMTru_4R (SYSMIS=-99).
EXECUTE.

*Defining missing values.
MISSING VALUES  intro_consent CH_1 CH_2 CH_3 CH_4 CH_5 CH_7 CH_8 CH_9 CH_10 CH_11 CH_12 CH_13 CH_14 CH_15 CH_16 
    CH_17 CH_18 CH_19 CH_21 HW_satisf HW_preference_1_1_1 HW_preference_2_1_1 HW_preference_3_1_1 HW_preference_4_1_1 
    HW_preference_5_1_1 HW_preference_1_2_1 HW_preference_2_2_1 HW_preference_3_2_1 HW_preference_4_2_1 HW_preference_5_2_1 InterJ_1 
    InterJ_2 InterJ_3 InfoJ_1 InfoJ_2 InfoJ_3 InfoJ_4 InfoJ_5 ProcJ_1 ProcJ_2 ProcJ_3 ProcJ_4 
    ProcJ_5 ProcJ_6 DistrJ_1 DistrJ_2 DistrJ_3 DistrJ_4 HELP_1 HELP_2 HELP_3 PROMT_1 PROMT_2 PROMT_3 
    PROMC_1 PROMC_2 PROMC_3 PROMC_4 PROMR_1 PROMR_2 PROMR_3 TPROF_1 TPROF_2 TPROF_3 CWB_1 CWB_2 CWB_3 
    PREVT_1 PREVT_2 PREVT_3 PREVC_2 PREVC_3 PREVR_1 PREVR_2 PREVR_3 Eng_1 Eng_2 Eng_3 Eng_4 EXHAU_1 
    EXHAU_2 EXHAU_3 JS_1 OJ_1 OJ_2 OJ_3 PA_1 PA_2 PA_3 PA_4 PA_5 NA_1 NA_2 NA_3 NA_4 NA_5 drive drain 
    WBMST_1 WBMST_2 WBMST_3 WBREL_1 WBREL_2 WBREL_3 Aut_1 Aut_2 Aut_3 Extra_1 Agree_1 Con_1 Neuro_1 
    Open_1 Extra_2 Agree_2 Con_2 Neuro_2 Open_2 Attention_1 LM_function LM_interact LPSS_1 LPSS_2 
    LPSS_3 LPSS_4 LTRU_1 LTRU_2 LTRU_3 LTRU_4 LTRU_5 LOP_1 LOP_2 LOP_3 LOP_4 LCL_1 LCL_2 LCL_3 LCL_4 
    TM_interact TMLPS_1 TMLPS_2 TMLPS_3 TMLPS_4 TMTru_1 TMTru_2 TMTru_3 TMTru_4 TMTru_5 TMOP_1 TMOP_2 
    TMOP_3 TMOP_4 TMCL_1 TMCL_2 TMCL_3 TMCL_4 Location Segment Mgt_level Gender Job_role FT_PT FT_PT_2_TEXT Tenure Age 
    Ethnicity workhours daysoff Consent_Future workhours_corrected 
    drainR WBMST_1R WBREL_1R WBREL_3R Extra_1R Agree_2R Con_1R Neuro_1R Open_1R LPSS_4R LTRU_3R LTRU_4R TMLPS_4R TMTru_3R, TMTru_4R (-1, -99).
EXECUTE.

MISSING VALUES Counterfact_HWtext HW_preference_5_1_TEXT HW_preference_5_2_TEXT Job_role_10_TEXT ("-99").
EXECUTE.

*2. Computing factors.

*CH factor.
COMPUTE CH = MEAN.10 (CH_1, CH_2, CH_3, CH_4, CH_5, CH_7, CH_8, CH_9, CH_10, CH_11, CH_12, CH_13, CH_14, CH_15, CH_16, CH_17, CH_18, CH_19, CH_21).
VARIABLE LABELS CH "CH factor".
EXECUTE.

RELIABILITY
  /VARIABLES=CH_1, CH_2, CH_3, CH_4, CH_5, CH_7, CH_8, CH_9, CH_10, CH_11, CH_12, CH_13, CH_14, CH_15, CH_16, CH_17, CH_18, CH_19, CH_21 
  /SCALE('ALL VARIABLES') ALL
  /MODEL=ALPHA
  /STATISTICS=DESCRIPTIVE SCALE
  /SUMMARY=TOTAL.

*INTERJ factor.
COMPUTE INTERJ = MEAN.2 (InterJ_1, InterJ_2, InterJ_3).
VARIABLE LABELS INTERJ "Interactional Justice".
EXECUTE.

RELIABILITY
  /VARIABLES=InterJ_1, InterJ_2, InterJ_3
  /SCALE('ALL VARIABLES') ALL
  /MODEL=ALPHA
  /STATISTICS=DESCRIPTIVE SCALE
  /SUMMARY=TOTAL.

*INTERJ factor 2-item.
COMPUTE INTERJ_2item = MEAN.2 (InterJ_1, InterJ_2).
VARIABLE LABELS INTERJ_2item "Interactional Justice 2-item".
EXECUTE.

RELIABILITY
  /VARIABLES=InterJ_1, InterJ_2
  /SCALE('ALL VARIABLES') ALL
  /MODEL=ALPHA
  /STATISTICS=DESCRIPTIVE SCALE
  /SUMMARY=TOTAL.

*INFOJ factor.
COMPUTE INFOJ = MEAN.3 (InfoJ_1, InfoJ_2, InfoJ_3, InfoJ_4, InfoJ_5).
VARIABLE LABELS INFOJ "Informational Justice".
EXECUTE.

RELIABILITY
  /VARIABLES=InfoJ_1, InfoJ_2, InfoJ_3, InfoJ_4, InfoJ_5
  /SCALE('ALL VARIABLES') ALL
  /MODEL=ALPHA
  /STATISTICS=DESCRIPTIVE SCALE
  /SUMMARY=TOTAL.

*PROCJ factor.
COMPUTE PROCJ = MEAN.3 (ProcJ_1, ProcJ_2, ProcJ_3, ProcJ_4, ProcJ_5, ProcJ_6).
VARIABLE LABELS PROCJ "Procedural Justice".
EXECUTE.

RELIABILITY
  /VARIABLES=ProcJ_1, ProcJ_2, ProcJ_3, ProcJ_4, ProcJ_5, ProcJ_6
  /SCALE('ALL VARIABLES') ALL
  /MODEL=ALPHA
  /STATISTICS=DESCRIPTIVE SCALE
  /SUMMARY=TOTAL.

*DISTRJ factor.
COMPUTE DISTRJ = MEAN.2 (DistrJ_1, DistrJ_2, DistrJ_3, DistrJ_4).
VARIABLE LABELS DISTRJ "Distributive Jutice".
EXECUTE.

RELIABILITY
  /VARIABLES=DistrJ_1, DistrJ_2, DistrJ_3, DistrJ_4
  /SCALE('ALL VARIABLES') ALL
  /MODEL=ALPHA
  /STATISTICS=DESCRIPTIVE SCALE
  /SUMMARY=TOTAL.

*HELP factor.
COMPUTE HELP = MEAN.2 (HELP_1, HELP_2, HELP_3).
VARIABLE LABELS HELP "Helping".
EXECUTE.

RELIABILITY
  /VARIABLES=HELP_1, HELP_2, HELP_3
  /SCALE('ALL VARIABLES') ALL
  /MODEL=ALPHA
  /STATISTICS=DESCRIPTIVE SCALE
  /SUMMARY=TOTAL.

*PROMT factor.

COMPUTE PROMT = MEAN.2 (PROMT_1, PROMT_2, PROMT_3).
VARIABLE LABELS PROMT "Promotion-oriented behaviour (Task crafting)".
EXECUTE.

RELIABILITY
  /VARIABLES=PROMT_1, PROMT_2, PROMT_3
  /SCALE('ALL VARIABLES') ALL
  /MODEL=ALPHA
  /STATISTICS=DESCRIPTIVE SCALE
  /SUMMARY=TOTAL.

*PROMC factor.

COMPUTE PROMC = MEAN.2 (PROMC_1, PROMC_2, PROMC_3, PROMC_4).
VARIABLE LABELS PROMC "Promotion-oriented behaviour (Cognitive crafting)".
EXECUTE.

RELIABILITY
  /VARIABLES=PROMC_1, PROMC_2, PROMC_3, PROMC_4
  /SCALE('ALL VARIABLES') ALL
  /MODEL=ALPHA
  /STATISTICS=DESCRIPTIVE SCALE
  /SUMMARY=TOTAL.

COMPUTE PROMR = MEAN.2 (PROMR_1, PROMR_2, PROMR_3).
VARIABLE LABELS PROMR "Promotion-oriented behaviour (relational crafting)".
EXECUTE.

RELIABILITY
  /VARIABLES=PROMR_1, PROMR_2, PROMR_3
  /SCALE('ALL VARIABLES') ALL
  /MODEL=ALPHA
  /STATISTICS=DESCRIPTIVE SCALE
  /SUMMARY=TOTAL.

*TPROF factor.

COMPUTE TPROF = MEAN.2 (TPROF_1, TPROF_2, TPROF_3).
VARIABLE LABELS TPROF "Task-related performance".
EXECUTE.

RELIABILITY
  /VARIABLES=TPROF_1, TPROF_2, TPROF_3
  /SCALE('ALL VARIABLES') ALL
  /MODEL=ALPHA
  /STATISTICS=DESCRIPTIVE SCALE
  /SUMMARY=TOTAL.

*CWB factor.
COMPUTE CWB = MEAN.2 (CWB_1, CWB_2, CWB_3).
VARIABLE LABELS CWB "Counterproductive work behaviour".
EXECUTE.

RELIABILITY
  /VARIABLES=CWB_1, CWB_2, CWB_3
  /SCALE('ALL VARIABLES') ALL
  /MODEL=ALPHA
  /STATISTICS=DESCRIPTIVE SCALE
  /SUMMARY=TOTAL.

*PREVT factor.
COMPUTE PREVT = MEAN.2 (PREVT_1, PREVT_2, PREVT_3).
VARIABLE LABELS PREVT "Prevention-oriented behaviour (Task crafting)".
EXECUTE.

RELIABILITY
  /VARIABLES=PREVT_1, PREVT_2, PREVT_3
  /SCALE('ALL VARIABLES') ALL
  /MODEL=ALPHA
  /STATISTICS=DESCRIPTIVE SCALE
  /SUMMARY=TOTAL.

*PREVC factor.
COMPUTE PREVC = MEAN.2 (PREVC_2, PREVC_3).
VARIABLE LABELS PREVC "Prevention-oriented behaviour (Cognitive crafting)".
EXECUTE.

RELIABILITY
  /VARIABLES=PREVC_2, PREVC_3
  /SCALE('ALL VARIABLES') ALL
  /MODEL=ALPHA
  /STATISTICS=DESCRIPTIVE SCALE
  /SUMMARY=TOTAL.

*PREVT_PREVC factor.
COMPUTE PREVT_PREVC = MEAN.3 (PREVT_1, PREVT_2, PREVT_3, PREVC_2, PREVC_3).
VARIABLE LABELS PREVT_PREVC "Prevention-oriented behaviour (task and cognitive crafting)".
EXECUTE.

RELIABILITY
  /VARIABLES=PREVT_1, PREVT_2, PREVT_3, PREVC_2, PREVC_3
  /SCALE('ALL VARIABLES') ALL
  /MODEL=ALPHA
  /STATISTICS=DESCRIPTIVE SCALE
  /SUMMARY=TOTAL.

*PREVR factor.
COMPUTE PREVR = MEAN.2 (PREVR_1, PREVR_2, PREVR_3).
VARIABLE LABELS PREVR "Prevention-oriented behaviour (Relationship crafting)".
EXECUTE.

RELIABILITY
  /VARIABLES=PREVR_1, PREVR_2, PREVR_3
  /SCALE('ALL VARIABLES') ALL
  /MODEL=ALPHA
  /STATISTICS=DESCRIPTIVE SCALE
  /SUMMARY=TOTAL.

*ENG factor.
COMPUTE ENG = MEAN.2 (Eng_1, Eng_2, Eng_3, Eng_4).
VARIABLE LABELS ENG "Engagement".
EXECUTE.

RELIABILITY
  /VARIABLES=Eng_1, Eng_2, Eng_3, Eng_4
  /SCALE('ALL VARIABLES') ALL
  /MODEL=ALPHA
  /STATISTICS=DESCRIPTIVE SCALE
  /SUMMARY=TOTAL.

*ENG factor 3-item.
COMPUTE ENG_3item = MEAN.2 (Eng_1, Eng_2, Eng_3).
VARIABLE LABELS ENG_3item "Engagement 3-item".
EXECUTE.

RELIABILITY
  /VARIABLES=Eng_1, Eng_2, Eng_3
  /SCALE('ALL VARIABLES') ALL
  /MODEL=ALPHA
  /STATISTICS=DESCRIPTIVE SCALE
  /SUMMARY=TOTAL.

*EXHAU factor.
COMPUTE EXHAU  = MEAN.2 (EXHAU_1, EXHAU_2, EXHAU_3).
VARIABLE LABELS EXHAU "Exhaustion".
EXECUTE.

RELIABILITY
  /VARIABLES=EXHAU_1, EXHAU_2, EXHAU_3
  /SCALE('ALL VARIABLES') ALL
  /MODEL=ALPHA
  /STATISTICS=DESCRIPTIVE SCALE
  /SUMMARY=TOTAL.

*OJ factor.
COMPUTE OJ = MEAN.2 (OJ_1, OJ_2, OJ_3).
VARIABLE LABELS OJ "Organizational Justice".
EXECUTE.

RELIABILITY
  /VARIABLES=OJ_1, OJ_2, OJ_3
  /SCALE('ALL VARIABLES') ALL
  /MODEL=ALPHA
  /STATISTICS=DESCRIPTIVE SCALE
  /SUMMARY=TOTAL.

*PA factor.
COMPUTE PA = MEAN.3 (PA_1, PA_2, PA_3, PA_4, PA_5).
VARIABLE LABELS PA "Positive mood".
EXECUTE.

RELIABILITY
  /VARIABLES=PA_1, PA_2, PA_3, PA_4, PA_5
  /SCALE('ALL VARIABLES') ALL
  /MODEL=ALPHA
  /STATISTICS=DESCRIPTIVE SCALE
  /SUMMARY=TOTAL.

*NA factor.
COMPUTE NA = MEAN.3 (NA_1, NA_2, NA_3, NA_4, NA_5).
VARIABLE LABELS NA "Negative Mood".
EXECUTE.

RELIABILITY
  /VARIABLES=NA_1, NA_2, NA_3, NA_4, NA_5
  /SCALE('ALL VARIABLES') ALL
  /MODEL=ALPHA
  /STATISTICS=DESCRIPTIVE SCALE
  /SUMMARY=TOTAL.

*DRIVE_DRAIN factor.
COMPUTE DRIVE_DRAIN = MEAN.2 (drive, drainR).
VARIABLE LABELS DRIVE_DRAIN "Drive & Drain".
EXECUTE.

RELIABILITY
  /VARIABLES=drive, drainR
  /SCALE('ALL VARIABLES') ALL
  /MODEL=ALPHA
  /STATISTICS=DESCRIPTIVE SCALE
  /SUMMARY=TOTAL.

*WBMST factor.
COMPUTE WBMST = MEAN.2 (WBMST_1R, WBMST_2, WBMST_3).
VARIABLE LABELS WBMST "Mastery (psych WB)".
EXECUTE.

RELIABILITY
  /VARIABLES=WBMST_1R, WBMST_2, WBMST_3
  /SCALE('ALL VARIABLES') ALL
  /MODEL=ALPHA
  /STATISTICS=DESCRIPTIVE SCALE
  /SUMMARY=TOTAL.

*WBREL factor.
COMPUTE WBREL = MEAN.2 (WBREL_1R, WBREL_2, WBREL_3R).
VARIABLE LABELS WBREL "Positive relationships (psych WB)".
EXECUTE.

RELIABILITY
  /VARIABLES=WBREL_1R, WBREL_2, WBREL_3R
  /SCALE('ALL VARIABLES') ALL
  /MODEL=ALPHA
  /STATISTICS=DESCRIPTIVE SCALE
  /SUMMARY=TOTAL.

*AUT factor.
COMPUTE AUT = MEAN.2 (Aut_1, Aut_2, Aut_3).
VARIABLE LABELS AUT "Autonomy at work".
EXECUTE.

RELIABILITY
  /VARIABLES=Aut_1, Aut_2, Aut_3
  /SCALE('ALL VARIABLES') ALL
  /MODEL=ALPHA
  /STATISTICS=DESCRIPTIVE SCALE
  /SUMMARY=TOTAL.

*Extraversion.
COMPUTE EXTRAVERSION = MEAN.2 (Extra_1R, Extra_2).
VARIABLE LABELS EXTRAVERSION "Extraversion".
EXECUTE.

RELIABILITY
  /VARIABLES=Extra_1R, Extra_2
  /SCALE('ALL VARIABLES') ALL
  /MODEL=ALPHA
  /STATISTICS=DESCRIPTIVE SCALE
  /SUMMARY=TOTAL.

*Agreeableness.
COMPUTE AGREEABLENESS = MEAN.2 (Agree_1, Agree_2R).
VARIABLE LABELS AGREEABLENESS "Agreeableness".
EXECUTE.

RELIABILITY
  /VARIABLES=Agree_1, Agree_2R
  /SCALE('ALL VARIABLES') ALL
  /MODEL=ALPHA
  /STATISTICS=DESCRIPTIVE SCALE
  /SUMMARY=TOTAL.

*Conscientiousness.
COMPUTE CONSCIENTIOUSNESS = MEAN.2 (Con_1R, Con_2).
VARIABLE LABELS CONSCIENTIOUSNESS "Conscientiousness".
EXECUTE.

RELIABILITY
  /VARIABLES=Con_1R, Con_2
  /SCALE('ALL VARIABLES') ALL
  /MODEL=ALPHA
  /STATISTICS=DESCRIPTIVE SCALE
  /SUMMARY=TOTAL.

*Neuroticism.
COMPUTE NEUROTICISM = MEAN.2 (Neuro_1R, Neuro_2).
VARIABLE LABELS NEUROTICISM "Neuroticism".
EXECUTE.

RELIABILITY
  /VARIABLES=Neuro_1R, Neuro_2
  /SCALE('ALL VARIABLES') ALL
  /MODEL=ALPHA
  /STATISTICS=DESCRIPTIVE SCALE
  /SUMMARY=TOTAL.

*Openness to Experience.
COMPUTE OPENNESS = MEAN.2 (Open_1R, Open_2).
VARIABLE LABELS OPENNESS "Openness to Experience".
EXECUTE.

RELIABILITY
  /VARIABLES=Open_1R, Open_2
  /SCALE('ALL VARIABLES') ALL
  /MODEL=ALPHA
  /STATISTICS=DESCRIPTIVE SCALE
  /SUMMARY=TOTAL.

*LPSS factor.
COMPUTE LPSS = MEAN.2 (LPSS_1, LPSS_2, LPSS_3, LPSS_4R).
VARIABLE LABELS LPSS "Supporting Leadership Behaviour (Leader Perspective)".
EXECUTE.

RELIABILITY
  /VARIABLES=LPSS_1, LPSS_2, LPSS_3, LPSS_4R 
  /SCALE('ALL VARIABLES') ALL
  /MODEL=ALPHA
  /STATISTICS=DESCRIPTIVE SCALE
  /SUMMARY=TOTAL.

*LPSS factor 3-item.
COMPUTE LPSS_3item = MEAN.2 (LPSS_1, LPSS_2, LPSS_3).
VARIABLE LABELS LPSS_3item "Supporting Leadership Behaviour (Leader Perspective) 3-item".
EXECUTE.

RELIABILITY
  /VARIABLES=LPSS_1, LPSS_2, LPSS_3 
  /SCALE('ALL VARIABLES') ALL
  /MODEL=ALPHA
  /STATISTICS=DESCRIPTIVE SCALE
  /SUMMARY=TOTAL.

*LPSS factor 2-item.
COMPUTE LPSS_2item = MEAN.2 (LPSS_1, LPSS_2).
VARIABLE LABELS LPSS_2item "Supporting Leadership Behaviour (Leader Perspective) 2-item".
EXECUTE.

RELIABILITY
  /VARIABLES=LPSS_1, LPSS_2 
  /SCALE('ALL VARIABLES') ALL
  /MODEL=ALPHA
  /STATISTICS=DESCRIPTIVE SCALE
  /SUMMARY=TOTAL.

*LTRU factor.
COMPUTE LTRU = MEAN.3 (LTRU_1, LTRU_2, LTRU_3R, LTRU_4R, LTRU_5).
VARIABLE LABELS LTRU "Trusting Employees (Leader Perspective)".
EXECUTE.

RELIABILITY
  /VARIABLES=LTRU_1, LTRU_2, LTRU_3R, LTRU_4R, LTRU_5
  /SCALE('ALL VARIABLES') ALL
  /MODEL=ALPHA
  /STATISTICS=DESCRIPTIVE SCALE
  /SUMMARY=TOTAL.

*LOP factor.
COMPUTE LOP = MEAN.2 (LOP_1, LOP_2, LOP_3, LOP_4).
VARIABLE LABELS LOP "Leadership Opening Behaviours (Leader Perspective)".
EXECUTE.

RELIABILITY
  /VARIABLES=LOP_1, LOP_2, LOP_3, LOP_4
  /SCALE('ALL VARIABLES') ALL
  /MODEL=ALPHA
  /STATISTICS=DESCRIPTIVE SCALE
  /SUMMARY=TOTAL.

*LCL factor.
COMPUTE LCL = MEAN.2 (LCL_1, LCL_2, LCL_3, LCL_4).
VARIABLE LABELS LCL "Leadership Closing Behaviours (Leader Perspective)".
EXECUTE.

RELIABILITY
  /VARIABLES=LCL_1, LCL_2, LCL_3, LCL_4
  /SCALE('ALL VARIABLES') ALL
  /MODEL=ALPHA
  /STATISTICS=DESCRIPTIVE SCALE
  /SUMMARY=TOTAL.

*TMLPS factor.
COMPUTE TMLPS = MEAN.2 (TMLPS_1, TMLPS_2, TMLPS_3, TMLPS_4R).
VARIABLE LABELS TMLPS "Supporting Leadership Behaviour (Team member Perspective)".
EXECUTE.

RELIABILITY
  /VARIABLES=TMLPS_1, TMLPS_2, TMLPS_3, TMLPS_4R
  /SCALE('ALL VARIABLES') ALL
  /MODEL=ALPHA
  /STATISTICS=DESCRIPTIVE SCALE
  /SUMMARY=TOTAL.

*TMLPS factor 3-item.
COMPUTE TMLPS_3item = MEAN.2 (TMLPS_1, TMLPS_2, TMLPS_3).
VARIABLE LABELS TMLPS_3item "Supporting Leadership Behaviour (Team member Perspective) 3-item".
EXECUTE.

RELIABILITY
  /VARIABLES=TMLPS_1, TMLPS_2, TMLPS_3
  /SCALE('ALL VARIABLES') ALL
  /MODEL=ALPHA
  /STATISTICS=DESCRIPTIVE SCALE
  /SUMMARY=TOTAL.

*TMTRU factor.
COMPUTE TMTRU = MEAN.3 (TMTru_1, TMTru_2, TMTru_3R, TMTru_4R, TMTru_5).
VARIABLE LABELS TMTRU "Trusting Employees (Team member Perspective)".
EXECUTE.

RELIABILITY
  /VARIABLES=TMTru_1, TMTru_2, TMTru_3R, TMTru_4R, TMTru_5
  /SCALE('ALL VARIABLES') ALL
  /MODEL=ALPHA
  /STATISTICS=DESCRIPTIVE SCALE
  /SUMMARY=TOTAL.

*TMOP factor.
COMPUTE TMOP = MEAN.2 (TMOP_1, TMOP_2, TMOP_3, TMOP_4).
VARIABLE LABELS TMOP "Leadership Opening Behaviours (Team member Perspective)".
EXECUTE.

RELIABILITY
  /VARIABLES=TMOP_1, TMOP_2, TMOP_3, TMOP_4
  /SCALE('ALL VARIABLES') ALL
  /MODEL=ALPHA
  /STATISTICS=DESCRIPTIVE SCALE
  /SUMMARY=TOTAL.

*TMCL factor.
COMPUTE TMCL = MEAN.2 (TMCL_1, TMCL_2, TMCL_3, TMCL_4).
VARIABLE LABELS TMCL "Leadership Closing Behaviours (Team member Perspective)".
EXECUTE.

RELIABILITY
  /VARIABLES=TMCL_1, TMCL_2, TMCL_3, TMCL_4
  /SCALE('ALL VARIABLES') ALL
  /MODEL=ALPHA
  /STATISTICS=DESCRIPTIVE SCALE
  /SUMMARY=TOTAL.

RECODE CH to TMCL (SYSMIS=-99).
EXECUTE.

*Defining missing values.
MISSING VALUES CH to TMCL (-99).
EXECUTE.


SPSSINC CREATE DUMMIES VARIABLE=Gender 
ROOTNAME1=Female 
/OPTIONS ORDER=A USEVALUELABELS=YES USEML=YES OMITFIRST=NO.

RECODE Gender (1=1) (2=0) (SYSMIS=SYSMIS) (ELSE=SYSMIS) INTO Female.
VARIABLE LABELS  Female 'Female'.
VALUE LABELS Female
   1 'Female'
   0 'Male'.
EXECUTE.

RECODE  Job_role (1=1) (SYSMIS=SYSMIS) (ELSE=0) INTO  Billable.
VARIABLE LABELS  Billable 'Billable job role vs rest'.
VALUE LABELS Billable
   1 'Billable job role'
   0 'Other job role'.
EXECUTE.

RECODE  Location  (1=1) (SYSMIS=SYSMIS) (ELSE=0) INTO  UK.
VARIABLE LABELS  UK 'UK vs rest'.
VALUE LABELS UK
   1 'UK'
   0 'Other countries'.
EXECUTE.


* Wellbeing super factors
    
COMPUTE SWB_NEG = MEAN (EXHAU, NA, drain).
COMPUTE SWB_POS = MEAN ( ENG, PA,  drive).
VARIABLE LABELS  SWB_NEG 'Negative wellbeing (exhaustion, neg mood, drain)'/SWB_POS 'Positive wellbeing (engagement, pos mood, energized)'.
    

DATASET ACTIVATE DataSet2.
FREQUENCIES VARIABLES=SWB_NEG SWB_POS
  /STATISTICS=STDDEV MINIMUM MAXIMUM MEAN
  /ORDER=ANALYSIS.

COMPUTE CH_EFF = MEAN (CH_5, CH_7, CH_8, CH_9, CH_16, CH_17).
VARIABLE LABELS  CH_EFF 'Changes in effectiveness of working due to Covid'.

RELIABILITY
  /VARIABLES=CH_5, CH_7, CH_8, CH_9, CH_16, CH_17
  /SCALE('ALL VARIABLES') ALL
  /MODEL=ALPHA
  /STATISTICS=DESCRIPTIVE SCALE
  /SUMMARY=TOTAL.

COMPUTE CH_PRESS = MEAN (CH_3, CH_2, CH_1, CH_4).
VARIABLE LABELS  CH_PRESS 'Changes in work pressures due to Covid'.

RELIABILITY
  /VARIABLES=CH_3, CH_2, CH_1, CH_4
  /SCALE('ALL VARIABLES') ALL
  /MODEL=ALPHA
  /STATISTICS=DESCRIPTIVE SCALE
  /SUMMARY=TOTAL.

COMPUTE CH_PROM = MEAN (CH_19, CH_18).
VARIABLE LABELS  CH_PROM 'Changes in how much company fulfills expecations to Covid'.

RELIABILITY
  /VARIABLES=CH_19, CH_18
  /SCALE('ALL VARIABLES') ALL
  /MODEL=ALPHA
  /STATISTICS=DESCRIPTIVE SCALE
  /SUMMARY=TOTAL.

COMPUTE CH_FLEX = MEAN (CH_11, CH_12, CH_13).
VARIABLE LABELS  CH_FLEX 'Changes in flexibillity due to Covid'.

RELIABILITY
  /VARIABLES=CH_11, CH_12, CH_13
  /SCALE('ALL VARIABLES') ALL
  /MODEL=ALPHA
  /STATISTICS=DESCRIPTIVE SCALE
  /SUMMARY=TOTAL.

COMPUTE CH_MEAN = MEAN (CH_14, CH_15).
VARIABLE LABELS  CH_MEAN 'Changes in meaningfulness due to Covid'.

RELIABILITY
  /VARIABLES=CH_14, CH_15
  /SCALE('ALL VARIABLES') ALL
  /MODEL=ALPHA
  /STATISTICS=DESCRIPTIVE SCALE
  /SUMMARY=TOTAL.

FREQUENCIES VARIABLES=CH_PRESS CH_PROM CH_FLEX CH_MEAN
  /STATISTICS=STDDEV MINIMUM MAXIMUM MEAN
  /ORDER=ANALYSIS.



* recoding missings to 0 for HWP pref and practice 
    

DO IF ((HW_preference_1_1_1>0) or (HW_preference_2_1_1>0) or (HW_preference_3_1_1>0) or (HW_preference_4_1_1>0) or (HW_preference_5_1_1>0)).

RECODE HW_preference_1_1_1 HW_preference_2_1_1 HW_preference_3_1_1 HW_preference_4_1_1 
    HW_preference_5_1_1 (-99=0).

END IF. 

EXECUTE.


DO IF ((HW_preference_1_2_1>0) or (HW_preference_2_2_1>0) or (HW_preference_3_2_1>0) or (HW_preference_4_2_1>0) or (HW_preference_5_2_1>0)).

RECODE HW_preference_1_2_1 HW_preference_2_2_1 HW_preference_3_2_1 HW_preference_4_2_1 
    HW_preference_5_2_1 (-99=0).

END IF. 

EXECUTE.

* Short labels

VARIABLE LABELS
CH_1 "Work-life balance"
CH_2 "Ability to switch off after work"
CH_3 "Workload"
CH_4 "Pressure to be available"
CH_5 "Quality of your performance"
CH_7 "Effective working"
CH_8 "Distractions at work"
CH_9 "Ability to serve clients"
CH_10 "Clarity of work routines"
CH_11 "Autonomy at work"
CH_12 "Flexibility to arrange time"
CH_13 "Ability to accomodate non-work tasks into schedule"
CH_14 "Meaningfulness of job"
CH_15 "Sense of purpose at work"
CH_16 "Feeling connected to others at work"
CH_17 "Collaboration within and across team"
CH_18 "Meets expectations"
CH_19 "Fulfilled promises by company"
CH_21 "Sense of belonging at work".

RECODE Female_1 to CH_MEAN (SYSMIS=-99).
EXECUTE.

*Defining missing values.
MISSING VALUES Female_1 to CH_MEAN (-99).
EXECUTE.

*Saving as a new file (replace the destination folder with one you want to use).
SAVE OUTFILE='/Users/jerryluukkonen/Desktop/Hybrid Working survey folder/Data folder/Final folder/Hybrid Working survey (final: for checking data) 1 September.sav'.

DATASET CLOSE *.


* 040921
    
RENAME VARIABLES 
 (HW_preference_1_2_1 HW_preference_2_2_1 HW_preference_3_2_1 HW_preference_4_2_1 
    HW_preference_5_2_1 HW_preference_5_2_TEXT =  HW_practice_1 HW_practice_2 HW_practice_3 HW_practice_4
    HW_practice_5 HW_practice_6).


RECODE Location (1=1) (2=2) (3=3) (4=4) (5=5) (6=6) (11=8) (7 thru 10=7) (ELSE=Copy) INTO Country.
VARIABLE LABELS  Country 'Country'.
VALUE LABELS country
                                    1 "United Kingdom"
		2 "Ireland"
		3 "Belgium"
		4 "France"
		5 "Germany"
		6 "Spain"
		7 "UAE and Qatar"
		8 "South Africa".
EXECUTE.

VALUE LABELS  HW_preference_1_1_1 HW_preference_2_1_1 HW_preference_3_1_1 
    HW_preference_4_1_1 HW_preference_5_1_1 HW_practice_1 HW_practice_2 HW_practice_3 HW_practice_4 HW_practice_5
    1 "Yes"
    0 "No".


COMPUTE PROMO = MEAN ( PROMT, PROMC ,PROMR).
VARIABLE LABELS PROMO 'Promotion-oriented behaviour (T,C,R)'.


COMPUTE PREVENT = MEAN (PREVT, PREVC, PREVR).
VARIABLE LABELS PREVENT 'Prevention-oriented behaviour (T,C,R)'.

* merging 
  
COMPUTE Interact = Mean (LM_interact,  TM_interact). 
VARIABLE LABELS Interact 'Opportunity to interact (with team or leader)'.

COMPUTE PSS = Mean (LPSS,  TMLPS). 
VARIABLE LABELS PSS 'Positive supervisor support (both)'.

COMPUTE TRU = Mean (LTRU,  TMTRU). 
VARIABLE LABELS TRU 'Trusted (both)'.

COMPUTE OPB = Mean (LOP,  TMOP). 
VARIABLE LABELS OPB 'Leader opening behaviours (both)'.

COMPUTE CLB = Mean (LCL,  TMCL). 
VARIABLE LABELS CLB 'Leader closing behaviours (both)'.


RECODE LM_function (1=1) (2=0) (ELSE=Copy) INTO LM_Di.
VARIABLE LABELS  LM_Di "Line management function (1‎/0)".

VALUE LABELS LM_di
    1 "Yes"
    0 "No".

EXECUTE.

DATASET ACTIVATE DataSet1.
RECODE HW_satisf (6=-1) (else=COPY).
MISSING VALUES HW_satisf (-1, -99).
EXECUTE.
