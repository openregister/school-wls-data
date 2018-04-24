# R Analysis of school-wls-data
## load packages:
library(readODS)
library(tidyverse)

# source/list file: '180410-address-list-schools-wales-ency.ods'
# source/list address: http://gov.wales/statistics-and-research/address-list-of-schools/?lang=en

# ODS spreadsheet, 14 tabs:
#     - Mynegai-Index
#     - T1 = Summary stats on Current Number of Schools
#     - T2 = Summary stats Type of Schools
#     - T3 = Summary stats Governance
#     - T4 = Summary stats Welsh Medium type
#     - T5 = Summary stats Religious Character
#     - A_gynhelir = Welsh version of 'Maintained' (skip)
#     - Annibynnol = Welsh version of 'Independent' (skip)
#     - UCD = Welsh version of 'PRU' (skip)
#     - Maintained = Maintained Schools ( Nursery, Primary, Middle, Secondary, Special)
#     - Independent = independant Schools
#     - PRU = Pupil Referral Units
#     - N1 = Notes
#     - N2 = Notes


# Mynegai-Index:
# - "Mynegai" welsh translation for index
# - index for the other tabs inthe spreadsheet

# T1
# - Contains summary stats on Current Number of Schools
# - contains: 
#     - a list of welsh local authorities
#     - a list of education consortia 
##! this list is reflected on line 263, 'Education consrtia' section.

# T2
# - Contains summary stats Type of Schools
# - same as aove

# T3
# - Contains Summary stats Governance
# - same as above

# T4
# - Contains Summary stats Welsh Medium type
# - same as above

# T5
# - Summary stats Religious Character
# - same as above


# Analysis of 'Maintained' sheet
#load file:
sh_maintained <- read_ods('180410-address-list-schools-wales-ency.ods', sheet = 10, col_types = NA)
# Observations: 1,521
# Variables: 17
# $ `School Number`                 <chr> "6602130", "6602131", "6602132", "6602133", "6602134", "6602135", "660213...
# $ `School Name`                   <chr> "Ysgol Gynradd Amlwch", "Ysgol Gynradd Beaumaris", "Ysgol Gynradd Bodeder...
# $ `LA Code`                       <chr> "660", "660", "660", "660", "660", "660", "660", "660", "660", "660", "66...
# $ `Local Authority`               <chr> "Isle of Anglesey", "Isle of Anglesey", "Isle of Anglesey", "Isle of Angl...
# $ Sector                          <chr> "Primary", "Primary", "Primary", "Primary", "Primary", "Primary", "Primar...
# $ `Governance - see notes`        <chr> "Community", "Community", "Community", "Community", "Community", "Communi...
# $ `WM Code`                       <chr> "WM", "WM", "WM", "WM", "WM", "WM", "WM", "WM", "WM", "WM", "WM", "WM", "...
# $ `Welsh Medium Type - see notes` <chr> "Welsh medium", "Welsh medium", "Welsh medium", "Welsh medium", "Welsh me...
# $ `School Type`                   <chr> "Nursery, Infants & Juniors", "Nursery, Infants & Juniors", "Nursery, Inf...
# $ `Religious Character`           <chr> "---", "---", "---", "---", "---", "---", "---", "---", "---", "---", "--...
# $ `Address 1`                     <chr> "Amlwch", "Maeshyfryd", "Bodedern", "Bodffordd", "Bodorgan", "Bryngwran",...
# $ `Address 2`                     <chr> "Ynys Môn", "Beaumaris", "Caergybi", "Llangefni", "Ynys Môn", "Caergybi",...
# $ `Address 3`                     <chr> NA, "Ynys Môn", "Ynys Môn", "Ynys Môn", NA, "Ynys Môn", "Ynys Môn", NA, "...
# $ `Address 4`                     <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, "Ynys Môn...
# $ Postcode                        <chr> "LL68 9DY", "LL58 8HL", "LL65 3TL", "LL77 7LZ", "LL62 5AB", "LL65 3PP", "...
# $ `Phone Number`                  <chr> "01407 830414", "01248 810451", "01407 740201", "01248 723384", "01407 84...
# $ `Pupils - see notes`            <chr> "278", "50", "112", "81", "22", "50", "42", "82", "42", "143", "35", "96"...

# Fields:
# - School Number == unique id, 7 digit number
check_unique_school_number_maintained <- length(unique(sh_maintained$`School Number`)) == nrow(sh_maintained)  # returns True, no duplicates
# - School Name == name, string
# - LA Code == 
#     - 'local authority code'?, 3 digit number, code used in current 'principal local authority register'.
#     - [] make a list of distinct local authorities
#     - [] make a link to the above register for these codes to the 'principal local authority' field to this register.
#     - [] check for 1:1 relationship with 'LA Code'
#     > draft register on 'Register Modelling tab'
# - Local Authority == 
#     - name of local authority,
#     - has a 1 to 1 relationship with LA Code
#     - use name field in register to display this
#     > draft register on 'Register Modelling tab'
df_localAuthority <- sh_maintained[,3:4]
df_localAuthority <- rename(df_localAuthority, 'LA_Code'='LA Code')
df_localAuthority <- rename(df_localAuthority, 'Local_Authority'='Local Authority')
df_localAuthority <- df_localAuthority %>% distinct(LA_Code,Local_Authority)

# - Sector ==
#     - classifications of type of schools/ or school phase
#     - contains 5 distinct entries
#     - [x] make an aux-register for sector 
#     > draft register on 'Register Modelling tab'
df_sector <-  as.data.frame(unique(sh_maintained[,5]))
df_sector$index <- seq.int(nrow(df_sector))
names(df_sector)[1] <- 'sector'

# - Governance ==
#     - classification of Governance (?)
#     - 5 distinct entries
#     - definitions listed below
#         - 'Community': Schools which are wholly owned and maintained by the local authority. 
#         The local authority is the admissions authority — it has main responsibility for deciding arrangements for admitting pupils.

#         - 'Voluntary aided': These are established by voluntary bodies, mainly the religious denominations, but are maintained by the LAs. 
#         The admission authority of a voluntary aided school is the governing body.

#         - 'Voluntary controlled': These are established by voluntary bodies, mainly the religious denominations, but are maintained by the LAs. 
#         The admission authority of a voluntary controlled school is the LA.

#         - 'Foundation': Foundation schools have more freedom than community schools to manage their school and decide on their own admissions. 
#         Funding comes from the local authority.
#         - 'Not Applicable': NA
#     > draft register on 'Register Modelling tab'
df_governance <- as.data.frame(unique(sh_maintained[,6]))
df_governance$index <- seq.int(nrow(df_governance))
names(df_governance)[1] <- 'governance'

# - WM Code ==
#     - 2 character string
#     - 9 distinct entries
#     - appears to be a classifiction
#     > draft register on 'Register Modelling tab'
# - Welsh Medium Type - see notes ==
#     - string
#     - 9 distinct entries
#     - definition of string entries below (definitions sourced from tab:N1):
#         - 'Welsh medium': Welsh is the day to day language of the school. Welsh is used as the language of communication with the pupils and for the school’s administration. 
#         The school communicates with parents in both languages.
#         - 'Dual Stream' (under primary school only in N1): Both Welsh and English are used in the day to day business of the school. 
#         The language of communication with the pupils is determined by the nature of the curricular provision, 
#         but in some schools high priority is given to creating a Welsh-language ethos throughout the school. 
#         The school communicates with parents in both languages.
#         - 'Transitional' (under primary school only in N1): Welsh is the language of the day to day business of the school. A high priority is given to creating a Welsh ethos. 
#         The school communicates with parents in both languages.
#         - 'English with significant Welsh': The day to day language or languages of the school are determined by the school’s linguistic context. 
#         Both languages are used as languages of communication with the pupils and for the school’s administration. 
#         A high priority is given to creating a Welsh ethos. The school communicates with parents in both languages.
#         - 'English medium': English is the language of the day to day business of the school, 
#         but some Welsh is also used as a language of communication with the pupils with the aim of improving their capacity to use everyday Welsh. 
#         The school communicates with parents either in English or in both languages.
#         - 'Bilingual (Category A)': At least 80% of subjects apart from English and Welsh are taught only through the medium of Welsh to all pupils.
#         One or two subjects are taught to some pupils in English or in both languages.
#         - 'Bilingual (Category B)': At least 80% of subjects (excluding Welsh and English) are taught through the medium of Welsh but are also taught through the medium of English.
#         - 'Bilingual (Category C)': 50-79% of subjects (excluding Welsh and English) are taught through the medium of Welsh but are also taught through the medium of English.
#         - 'Bilingual (Category Ch)': All subjects, except Welsh and English taught to all pupils using both languages.
#     - appears to be a 1:1 link between 'WM Code' and 'Welsh Medium Type'. Merge with current register for 'WM Code'
#     > draft register on 'Register Modelling tab' for 'WM Code' and ' Welsh Medium type'
df_welsh_medium_type <- as.data.frame(unique(sh_maintained[,7:8]))

# - School Type ==
#     - string type
#     - appears to be a classification
#     - 13 distinct entries
#     - appears to be granular detail on 'Sector' re: age range of students attending.
#     - if i was to combine with 'Sector', may even be able to create a field called 'student-type' - to represent the attending age-range of school.
#     > draft register on 'Register Modelling tab'
df_school_type <- as.data.frame(unique(sh_maintained[,9]))
df_school_type$index <- seq.int(nrow(df_school_type))
names(df_school_type)[1] <- 'school-type'

# - Religious Character ==
#     - string type
#     - appears to be a classification
#     - 4 distinct entries
#     - one entry '---' appears to signify 'NA', [] confirm with the custodian
#     > draft register on 'Register Modelling tab'
df_religious_char <- as.data.frame(unique(sh_maintained[,10]))
df_religious_char$index <- seq.int(nrow(df_religious_char))
names(df_religious_char)[1] <- 'religious-charachter'

# - Address Data ==
# - Address 1
# - Address 2
# - Address 3
# - Address 4
# - Postcode
#     - ^ the above is address data. 
#     - Will be replaced with a uprn.
# - Phone Number
#     - phone number for the school?, [] explicitly confirm this with custodian. - may even check with GDPR
# - Pupils - see notes
#     -  integer
#     - no. of students in school, gathered by census.
#     - blank entries signify 'new school' # could present a problem.
#     - if included, this may be a field in another table, prefeerable a register for individual schools.
# [x] add a 'sheet' column, to denote what sheet this dataset came from:
sh_maintained$sheet <- 'Maintained'

# End of analysis for 'Maintained' spreadsheet.


# Analysis of 'Independent' sheet
# Load file:
sh_independent <- read_ods('../lists/180410-address-list-schools-wales-ency.ods', sheet = 11,col_types = NA)
# Observations: 72
# Variables: 11
# $ `School Number`      <chr> "6606027", "6606028", "6616008", "6616022", "6616033", "6616034", "6626017", "662601...
# $ `School Name`        <chr> "Treffos School", "Caban Aur", "St Gerards School Trust", "Aran Hall School", "Teres...
# $ `LA Code`            <chr> "660", "660", "661", "661", "661", "661", "662", "662", "663", "663", "663", "663", ...
# $ `Local Authority`    <chr> "Isle of Anglesey", "Isle of Anglesey", "Gwynedd", "Gwynedd", "Gwynedd", "Gwynedd", ...
# $ `Address 1`          <chr> "Llansadwrn", "Llanbedrgoch", "Ffriddoedd Road", "Rhydymain", "Towyn Cottage", "The ...
# $ `Address 2`          <chr> "Nr Menai Bridge", "Anglesey", "Bangor", "Dolgellau", "Golf Road", NA, "Conwy", "Col...
# $ `Address 3`          <chr> "Anglesey", NA, "Gwynedd", "Gwynedd", "Pwllheli", "Ffordd Gwynedd", NA, "Conwy", "St...
# $ `Address 4`          <chr> NA, NA, NA, NA, "Gwynedd", "Bangor", NA, NA, "Denbighshire", NA, "Denbighshire", NA,...
# $ Postcode             <chr> "LL59 5SD", "LL76 8NX", "LL57 2EL", "LL40 2AR", "LL53 5PS", "LL57 1DT", "LL30 1RD", ...
# $ `Phone Number`       <chr> "01248 712322", "01248 450087", "01248 351656", "01341 450641", "07747 458889", "012...
# $ `Pupils - see notes` <chr> "117", "3", "155", "12", "4", NA, "223", "313", "93", "331", "16", "82", "17", "30",...

# -Fields:
#     - School Number ==
#         - unique id
#         - check analysis for 'Maintained' sheet.
#         - [] chceck for duplicates:
check_unique_school_number_independent <- length(unique(sh_independent$`School Number`)) == nrow(sh_independent) # resolves to TRUE
#         - [] check whether same schools are present in the 'Maintained' sheet
unique_ids_maintained <- sh_maintained$`School Number`
unique_ids_indepenedent <- sh_independent$`School Number`
check_overlapping_unique_ids <- intersect(unique_ids_maintained,unique_ids_indepenedent) # resloves to empty, no overlap.
#     - School Name ==
#         - name field
#         - check analysis for 'Maintained' sheet.
#         - [] check whether same schools are present in the 'Maintained' sheet
schoolName_maintained <- sh_maintained$`School Name`
schoolName_independent <- sh_independent$`School Name`
check_overlapping_schoolNames <- intersect(schoolName_maintained,schoolName_independent) # resolves to empty
#     - LA Code ==
#         - 3 digit integer
#         - 16 distinct entries
#         - check analysis for 'Maintained' sheet.
#         - [] check whether entries are duplicated in 'Maintained' sheet
laCode_maintained <- unique(sh_maintained$`LA Code`)
laCode_independant <-  unique(sh_independent$`LA Code`)
check_overapping_laCodes <- setdiff(laCode_maintained,laCode_independant) # 6 in difference, this matches the diff in length between sheets. Visual inspection confirms.
#     - Local Authority ==
#         - string
#         - 16 distinct entries
#     - Address 1
#     - Address 2
#     - Address 3
#     - Address 4
#     - Postcode
#         - ^ the above is address data.
#         - Will be replaced with a uprn.
#     - Phone Number ==
#         - phone number for the school?, [] explicitly confirm this with custodian.
# - Pupils - see notes
#     -  integer
#     - no. of students in school, gathered by census.
#     - blank entries signify 'new school' # could present a problem.
#     - if included, this may be a field in another table, prefeerable a register for individual schools.
#
# [x] add a 'sheet' column, to denote what sheet this dataset came from:
sh_independent$sheet <- 'Independent'
# End of analysis for 'Independent' spreadsheet.


# Analysis of 'PRU' sheet
# load file:
sh_pru <- read_ods('../lists/180410-address-list-schools-wales-ency.ods', sheet = 12, col_types = NA)
# Observations: 23
# Variables: 10
# $ `School Number`   <chr> "6611104", "6621100", "6621102", "6621103", "6621104", "6631100", "6641102", "6651104",...
# $ `School Name`     <chr> "Llechan Lân Centres", "Canolfan Addysg Nant-y-Bryniau Education Centre", "Gyffin Educa...
# $ `LA Code`         <chr> "661", "662", "662", "662", "662", "663", "664", "665", "666", "667", "668", "669", "66...
# $ `Local Authority` <chr> "Gwynedd", "Conwy", "Conwy", "Conwy", "Conwy", "Denbighshire", "Flintshire", "Wrexham",...
# $ `Address 1`       <chr> "Department of Education", "Abergele Hospital site", "Maes Y Llan", "Penrhos Avenue", "...
# $ `Address 2`       <chr> "Gwynedd Council", "Llanfair Road", "Gyffin", "Old Colwyn", NA, "Cefndy Road", "Nant Ma...
# $ `Address 3`       <chr> "Shirehall Street", "Abergele", "Conwy", "Colwyn Bay", "Old Colwyn", "Rhyl", "Buckley",...
# $ `Address 4`       <chr> "Caernarfon", "Conwy", NA, "Conwy", "Colwyn Bay", NA, NA, NA, NA, "Ceredigion", "Milfor...
# $ Postcode          <chr> "LL55 1SH", "LL22 8DP", "LL32 8NB", "LL29 9HW", "LL29 9HN", "LL18 2HG", "CH7 2PX", "LL1...
# $ `Phone Number`    <chr> "01286 679007", "01745 448742", "01492 592859", "01492 514925", "01492 581661", "01745 ...

# -Fields:
#     - School Number ==
#         - unique id
#         - check analysis for 'Maintained' sheet.
#         - [] check whether same schools are present in the 'Maintained' sheet
check_unique_school_number_pru <- length(unique(sh_pru$`School Number`)) == nrow(sh_pru) # resolves to TRUE
unique_ids_pru <- sh_pru$`School Number`
check_overlapping_unique_ids2 <- intersect(unique_ids_maintained,unique_ids_pru) # resloves to empty, no overlap. - no overlap means i can append dataframes.
#     - School Name ==
#         - name field
#         - check analysis for 'Maintained' sheet.
#         - [] check whether same schools are present in the 'Maintained' sheet
schoolName_pru <- sh_pru$`School Name`
check_overlapping_schoolNames2 <- intersect(schoolName_maintained,schoolName_pru) # resolves to zero
#     - LA Code ==
#         - 3 digit integer
#         - 18 distinct entries
#         - check analysis for 'Maintained' sheet.
#         - [] check whether entries are duplicated in 'Maintained' sheet
laCode_pru <- sh_pru$`LA Code`
check_overapping_laCodes2 <- setdiff(laCode_maintained,laCode_pru) # a diff of 4, visually confirmaed
#     - Local Authority ==
#         - string
#         - 18 distinct entries
#     - Address 1
#     - Address 2
#     - Address 3
#     - Address 4
#     - Postcode
#         - ^ the above is address data.
#         - Will be replaced with a uprn.
#     - Phone Number ==
#         - phone number for the school?, [] explicitly confirm this with custodian.
# - Pupils - see notes
#     - integer
#     - no. of students in school, gathered by census.
#     - blank entries signify 'new school' # could present a problem.
#     - if included, this may be a field in another table, prefeerable a register for individual schools.
# [x] add a 'sheet' column, to denote what sheet this dataset came from:
sh_pru$sheet <- 'pru'

# End of analysis for 'PRU' sheet.


# Meta Analysis of all sheets:
# From Index:
# - 'List' appears to be the master level for 'School Type'/'Sector'. Appears to be the level above 'Sector', which is the level above 'School Type'
#     - Hierachy:
#         - List
#             - Sector
#                 - School Type
# - Entries for 'Lists' are:
#     - Maintained
#     - Independent
#     - PRU
# - This should be a field in a register, where you combine all the schools tabs (Maintained, Independent, PRU) into one table
# - [] confirm with the custodian whether this is hierachy exists
# - [] make a decision whether to turn 'List' into a register, containing all sublevels (a self referential register, like allergens)

#From Maintained/Independent/PRU
# [] build a master-list of Local Authority codes (LA Code) and names (Local Authority) from all 3 tabs -- this will be the Local Authority reg (aux)


# Definition of terms:
#('N1' is a tab in the source/list file)

## Schools section of N1
# - Nursery: age under 5. Primary: ages 3/4 to 10. Middle: ages 3/4 to 16/18. Secondary: ages 11 to 16/18.
# - Special schools: both day and boarding, provide education for children with Special Educational Needs, who cannot be educated satisfactorily in mainstream schools.
# - Maintained: Schools maintained by the local authorities.

## Pupils section of N1
# - Schools’ data are derived from the Pupil Level Annual School Census returns and STATS 1 returns supplied by schools open on Census day in January each year. (Blank = new school.)

## Governance section of N1
# - 'Community': Schools which are wholly owned and maintained by the local authority. The local authority is the admissions authority — it has main responsibility for deciding arrangements for admitting pupils.
# - 'Voluntary aided': These are established by voluntary bodies, mainly the religious denominations, but are maintained by the LAs. The admission authority of a voluntary aided school is the governing body.
# - 'Voluntary controlled': These are established by voluntary bodies, mainly the religious denominations, but are maintained by the LAs. The admission authority of a voluntary controlled school is the LA.
# - 'Foundation': Foundation schools have more freedom than community schools to manage their school and decide on their own admissions. Funding comes from the local authority.
# - 'Not Applicable': NA

## Welsh medium type
# - 'Welsh medium': Welsh is the day to day language of the school. Welsh is used as the language of communication with the pupils and for the school’s administration. The school communicates with parents in both languages.
# - 'Dual Stream' (under primary school only in N1): Both Welsh and English are used in the day to day business of the school. The language of communication with the pupils is determined by the nature of the curricular provision, but in some schools high priority is given to creating a Welsh-language ethos throughout the school. The school communicates with parents in both languages.
# - 'Transitional' (under primary school only in N1): Welsh is the language of the day to day business of the school. A high priority is given to creating a Welsh ethos. The school communicates with parents in both languages.
# - 'English with significant Welsh': The day to day language or languages of the school are determined by the school’s linguistic context. Both languages are used as languages of communication with the pupils and for the school’s administration. A high priority is given to creating a Welsh ethos. The school communicates with parents in both languages.
# - 'English medium': English is the language of the day to day business of the school, but some Welsh is also used as a language of communication with the pupils with the aim of improving their capacity to use everyday Welsh. The school communicates with parents either in English or in both languages.
# - 'Bilingual (Category A)': At least 80% of subjects apart from English and Welsh are taught only through the medium of Welsh to all pupils. One or two subjects are taught to some pupils in English or in both languages.
# - 'Bilingual (Category B)': At least 80% of subjects (excluding Welsh and English) are taught through the medium of Welsh but are also taught through the medium of English.
# - 'Bilingual (Category C)': 50-79% of subjects (excluding Welsh and English) are taught through the medium of Welsh but are also taught through the medium of English.
# - 'Bilingual (Category Ch)': All subjects, except Welsh and English taught to all pupils using both languages.

## Education consortia - There are four formal Education consortia in Wales covering:
# - North Wales 
#     - Flintshire, 
#     - Conwy, 
#     - Wrexham,
#     - Gwynedd, 
#     - Isle of Anglesey,
#     - Denbighshire
# - South West and Mid Wales 
#     - Swansea,
#     - Neath Port Talbot,
#     - Carmarthenshire,
#     - Pembrokeshire,
#     - Powys,
#     - Ceredigion
# - Central South Wales 
#     - Bridgend,
#     - Cardiff,
#     - Merthyr Tydfil,
#     - Rhondda Cynon Taf,
#     - Vale of Glamorgan
# - South East Wales 
#     - Caerphilly,
#     - Monmouthshire,
#     - Newport,
#     - Blaenau Gwent,
#     - Torfaen

#Note on above ^^ - []Check whether the above list corresponds with the list of Local Authorities.

# Making registers
# Merge the 'sh' files to create one dataframe
# Note - No overlap in unique ids suggest the rows in each frame are unique, will use a 'union', 
# but first will need to alter the shape of eeach frame to conform with 'sh_maintained':
temp_independent <- sh_independent
temp_independent$Sector <- NA
temp_independent$'Governance - see notes' <- NA
temp_independent$'WM Code' <- NA
temp_independent$'Welsh Medium Type - see notes' <- NA
temp_independent$'School Type' <- NA
temp_independent$'Religious Character' <- NA

temp_pru <- sh_pru
temp_pru$Sector <- NA
temp_pru$'Governance - see notes' <- NA
temp_pru$'WM Code' <- NA
temp_pru$'Welsh Medium Type - see notes' <- NA
temp_pru$'School Type' <- NA
temp_pru$'Religious Character' <- NA
temp_pru$'Pupils - see notes' <- NA

# reorder columns to correspond with 'sh_maintained'.
temp_independent <- temp_independent %>% select(`School Number`,`School Name`,`LA Code`,`Local Authority`,Sector,`Governance - see notes`,`WM Code`,`Welsh Medium Type - see notes`,`School Type`,`Religious Character`,`Address 1`,`Address 2`,`Address 3`,`Address 4`,Postcode,`Phone Number`,`Pupils - see notes`,sheet)
temp_pru <- temp_pru %>% select(`School Number`,`School Name`,`LA Code`,`Local Authority`,Sector,`Governance - see notes`,`WM Code`,`Welsh Medium Type - see notes`,`School Type`,`Religious Character`,`Address 1`,`Address 2`,`Address 3`,`Address 4`,Postcode,`Phone Number`,`Pupils - see notes`,sheet)

# append 'temp' dataframes as 'df_allData:
df_allData <- rbind(sh_maintained,temp_independent,temp_pru) # 1616 roows

# Making school-wls registers:
df_allData$school_wls <- df_allData$`School Number`
#name
df_allData$name <- df_allData$`School Name`
#school-wls-local-authority
df_allData$local_authority <- df_allData$`LA Code`
df_allData$local_authority_name <- df_allData$`Local Authority`
df_allData$principle_local_authority_wls <- NA

#create a dataframe for list/sheet:
df_sheet <- as.data.frame(unique(df_allData$sheet))
df_sheet$index <- seq.int(nrow(df_sheet))
names(df_sheet)[1] <- 'school-wls-sheet'

#joining index columns for auxillary registers
df_allData <- df_allData %>% left_join(df_sheet, by = c('sheet' = 'school-wls-sheet') )
names(df_allData)[24] <- 'school-wls-sheet'

df_allData <- df_allData %>% left_join(df_sector, by = c('Sector' = 'sector'))
names(df_allData)[25] <- 'school-wls-sector'

df_allData <- df_allData %>% left_join(df_governance, by = c("Governance - see notes"='governance'))
names(df_allData)[26] <- 'school-wls-governance'

df_allData$school_wls_welsh_medium_code <- df_allData$`WM Code`

df_allData <- df_allData %>% left_join(df_school_type, by = c("School Type"="school-type"))
names(df_allData)[28] <- 'school-wls-school-type'

df_allData <- df_allData %>% left_join(df_religious_char, by = c("Religious Character"="religious-charachter"))
names(df_allData)[29] <- "school-wls-religious-character"

df_allData$address <- NA

df_allData$phone_number <- df_allData$`Phone Number`

df_allData$pupils <- df_allData$`Pupils - see notes`

names(df_allData)[21] <- 'school-wls-local-authority'
names(df_allData)[18] <- 'school-wls-sheet'
names(df_allData)[18] <- 'school-wls-sheetx'

#school-wls:
reg_school_wls <- df_allData %>% select(school_wls, name, `school-wls-local-authority`, `school-wls-sheet`, `school-wls-sector`, `school-wls-governance`, school_wls_welsh_medium_code, `school-wls-school-type`, `school-wls-religious-character`, address, phone_number, pupils)
write_tsv(reg_school_wls, path = '../data/school-wls.tsv')

#school-wls-local-authority:
reg_school_wls_local_authority <- df_localAuthority
reg_school_wls_local_authority$principle_local_authority <- NA
write_tsv(reg_school_wls_local_authority, path = '../data/school-wls-local-authority.tsv')

#school-wls-sector:
reg_school_wls_sector <- df_sector
write_tsv(reg_school_wls_sector, path = '../data/school-wls-sector.tsv')

#school-wls-governance:
reg_school_wls_governance <- df_governance
write_tsv(reg_school_wls_governance, path = '../data/school-wls-governance.tsv')

#school-wls-welsh-medium-code:
reg_school_wls_welsh_medium_code <- df_welsh_medium_type
write_tsv(reg_school_wls_welsh_medium_code, path = '../data/school-wls-welsh-medium-code.tsv')

#school-wls-school-type:
reg_school_wls_school_type <- df_school_type
write_tsv(reg_school_wls_school_type, path = '../data/school-wls-school-type.tsv')

#reg-school-wls-religious-character:
reg_school_wls_religious_character <- df_religious_char
write_tsv(reg_school_wls_religious_character, path = '../data/school-wls-religious-character.tsv')

#reg-school-wls-sheet:
reg_school_wls_sheet <- df_sheet
write_tsv(reg_school_wls_sheet, path = '../data/school-wls-sheet.tsv')

#reg-school-wls-education-consortia:
df_education_consortia <- df_localAuthority
df_education_consortia$education_consortia <- NA

df_education_consortia[1,3] <- 'North West'
df_education_consortia[2,3] <- 'North West'
df_education_consortia[3,3] <- 'North West'
df_education_consortia[4,3] <- 'North West'
df_education_consortia[5,3] <- 'North West'
df_education_consortia[6,3] <- 'North West'
df_education_consortia[7,3] <- 'South West and Mid Wales'
df_education_consortia[8,3] <- 'South West and Mid Wales'
df_education_consortia[9,3] <- 'South West and Mid Wales'
df_education_consortia[10,3] <- 'South West and Mid Wales'
df_education_consortia[11,3] <- 'South West and Mid Wales'
df_education_consortia[12,3] <- 'South West and Mid Wales'
df_education_consortia[13,3] <- 'Central South Wales'
df_education_consortia[14,3] <- 'Central South Wales'
df_education_consortia[15,3] <- 'Central South Wales'
df_education_consortia[16,3] <- 'Central South Wales'
df_education_consortia[17,3] <- 'South East Wales'
df_education_consortia[18,3] <- 'South East Wales'
df_education_consortia[19,3] <- 'South East Wales'
df_education_consortia[20,3] <- 'South East Wales'
df_education_consortia[21,3] <- 'South East Wales'
df_education_consortia[22,3] <- 'Central South Wales'

xx <- as.data.frame(unique(df_education_consortia$education_consortia))
xx$index <- seq.int(nrow(xx))
names(xx)[1] <- 'name'
names(xx)[2] <- 'school_wls_education_consortia'
reg_school_wls_education_consortia <- xx

write_tsv(reg_school_wls_education_consortia, '../data/school_wls_education_consortia.tsv')

# names(reg_school_wls_education_consortia)[1] <- 'namexx'
##join 'education consortia back on 
df_allData <- df_allData %>% left_join(reg_school_wls_education_consortia, by = c("education_consortia.x" = "namexx"))

#remove unwanted columns, and write 'school-wls':
df_allData$LA_Code.x <- NULL
df_allData$education_consortia.x <- NULL

reg_school_wls2 <- df_allData %>% select(school_wls, name, `school-wls-local-authority`, `school-wls-sheet`, `school-wls-sector`, `school-wls-governance`, school_wls_welsh_medium_code, `school-wls-school-type`, `school-wls-religious-character`, address, phone_number, pupils, school_wls_education_consortia)
write_tsv(reg_school_wls2, path = '../data/school-wls.tsv')

# Adding data from the 'principal local authority' register to the 'df_localAuthority' register, to allow for mapping.
df_localAuthority$principal_local_authority <- NA

df_principleLA <- read_tsv('../../local-authority-data/data/principal-local-authority/principal-local-authority.tsv')
temp1 <- df_principleLA %>% select(2,1)
temp1 <- left_join(df_localAuthority, temp1, by = c('Local_Authority'='name'))
temp1$principal_local_authority <- NULL
df_allData <-  left_join(df_allData,temp1, by = c('LA Code'='LA_Code'))

#making the 'school-wls' reg, version 3:
reg_school_wls3 <- df_allData %>% select(school_wls,`School Name`,`principal-local-authority`,`School Type`)
reg_school_wls3$address <- NA
reg_school_wls3 <- reg_school_wls3 %>% select(school_wls,`School Name`,`principal-local-authority`,address,`School Type`)


