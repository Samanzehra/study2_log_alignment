library(bupaR)
library(lubridate)
library(dplyr)
library(pm4py)
#pm4py here is not from CRAN but installed the development version with [remotes::install_github("bupaverse/pm4py")]
library(petrinetR)
library(reticulate)
library(heuristicsmineR)

# bupaR::simple_eventlog(eventlog = data,  case_id = "order_number", activity_id = "activity", timestamp = "time")

#read a dummy log for this course aml1 representing course learning design (ld). 
#gran.level = indiv activity (1.1A, 1.2V etc)
dummylog <- read.csv("ere_6_SimpleLog_bupaR.csv", fileEncoding = 'UTF-8-BOM')
str(dummylog)
dummylog$first_visited_at <- ymd_hms(dummylog$first_visited_at, quiet = FALSE, tz="UTC")
str(dummylog)

ere6_log <- bupaR::simple_eventlog(eventlog = dummylog,
                                   case_id = "learner_id", 
                                   activity_id = "activity_num", 
                                   timestamp = "first_visited_at")

str(ere6_log)
mapping(ere6_log)

# read the csv file for ere_6_all 
file0<- read.csv("ere_6_sa_full.csv", fileEncoding = 'UTF-8-BOM')
str(file0)
file0$first_visited_at <- ymd_hms(file0$first_visited_at, quiet = FALSE, tz="UTC")
str(file0)

# make an event log from the course event data file, gran.level = indiv activity (1.1 A, 1.2V, 1.3D, etc.)

# read and make event log for all
ere6_full <- bupaR::simple_eventlog(eventlog = file0,
                                  case_id = "learner_id", 
                                  activity_id = "activity_num", 
                                  timestamp = "first_visited_at")

str(ere6_full)
mapping(ere6_full)



# read the csv file for ere_6_FullMarkers

file1<- read.csv("ere_6_sa_FM.csv", fileEncoding = 'UTF-8-BOM')
str(file1)
file1$first_visited_at <- ymd_hms(file1$first_visited_at, quiet = FALSE, tz="UTC")
str(file1)

# make an event log from the course event data file, gran.level = indiv activity (1.1 A, 1.2V, 1.3D, etc.)

# read and make event log for Full-markers
ere6_FM <- bupaR::simple_eventlog(eventlog = file1,
                                     case_id = "learner_id", 
                                     activity_id = "activity_num", 
                                     timestamp = "first_visited_at")

str(ere6_FM)
mapping(ere6_FM)

# read and make event log for partial-markers
file2<- read.csv("ere_6_sa_PM.csv", fileEncoding = 'UTF-8-BOM')
str(file2)
file2$first_visited_at <- ymd_hms(file2$first_visited_at, quiet = FALSE, tz="UTC")
str(file2)

# make an event log from the course event data file, gran.level = indiv activity (1.1 A, 1.2V, 1.3D, etc.)

ere6_PM <- bupaR::simple_eventlog(eventlog = file2,
                                  case_id = "learner_id", 
                                  activity_id = "activity_num", 
                                  timestamp = "first_visited_at")

str(ere6_PM)
mapping(ere6_PM)

# read and make event log for Non markers
file3<- read.csv("ere_6_sa_NM.csv", fileEncoding = 'UTF-8-BOM')
str(file3)
file3$first_visited_at <- ymd_hms(file3$first_visited_at, quiet = FALSE, tz="UTC")
str(file3)

# make an event log from the course event data file, gran.level = indiv activity (1.1 A, 1.2V, 1.3D, etc.)

ere6_NM <- bupaR::simple_eventlog(eventlog = file3,
                                  case_id = "learner_id", 
                                  activity_id = "activity_num", 
                                  timestamp = "first_visited_at")

str(ere6_NM)
mapping(ere6_NM)

# Finding model and perform conformance checking for aml1_mm_full, all, and for individual CC, gran.level = indiv activity (1.1A, 1.2V etc.)
model_ere6_log <- discovery_inductive(ere6_log)
str(model_ere6_log)

#now evaluate fitness for full log,  FullMarkers (FM), PartialMarkers(PM), and NonMarkers(NM)
evaluation_all(ere6_full, model_ere6_log$petrinet, model_ere6_log$inital_marking, model_ere6_log$final_marking)
evaluation_fitness(ere6_full, model_ere6_log$petrinet, model_ere6_log$inital_marking, model_ere6_log$final_marking)
evaluation_fitness(ere6_FM, model_ere6_log$petrinet, model_ere6_log$inital_marking, model_ere6_log$final_marking)
evaluation_fitness(ere6_PM, model_ere6_log$petrinet, model_ere6_log$inital_marking, model_ere6_log$final_marking)
evaluation_fitness(ere6_NM, model_ere6_log$petrinet, model_ere6_log$inital_marking, model_ere6_log$final_marking)

