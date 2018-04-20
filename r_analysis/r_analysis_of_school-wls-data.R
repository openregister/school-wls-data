# R Analysis of school-wls-data
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
# Fields:
# - School Number == unique id, 7 digit number
# - School Name == name, string
# - LA Code == 
#     - 'local authority code'?, 3 digit number, code does not relate to current 'principal local authority register'.
#     - [] make a link to this register for these codes.
#     - could be its own register.
# - Local Authority == 
#     - name of local authority,
#     - has a 1 to 1 relationship with LA Code
#     - use name field in register to display this
#     > draft register on 'Register Modelling tab'
# - Sector ==
#     - classifications of type of schools/ or school phase
#     - contains 5 distinct entries
#     - [] make it its own table
#     > draft register on 'Register Modelling tab'
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
#     > draft register on 'Register Modelling tab'
# - School Type ==
#     - string type
#     - appears to be a classification
#     - 13 distinct entries
#     - appears to be granular detail on 'Sector' re: age range of students attending.
#     - if i was to combine with 'Sector', may even be able to create a field called 'student-type' - to represent the attending age-range of school.
#     > draft register on 'Register Modelling tab'
# - Religious Character ==
#     - string type
#     - appears to be a classification
#     - 4 distinct entries
#     - one entry '---' appears to signify 'NA', [] confirm with the custodian
# - Address 1
# - Address 2
# - Address 3
# - Address 4
# - Postcode
#     - ^ the above is address data. 
#     - Will be replaced with a uprn.
# - Phone Number
#     - phone number for the school?, [] explicitly confirm this with custodian.
# - Pupils - see notes
#     -  integer
#     - no. of students in school, gathered by census.
#     - blank entries signify 'new school' # could present a problem.
#     - if included, this may be a field in another table, prefeerable a register for individual schools.

# End of analysis for 'Maintained' spreadsheet.


# Analysis of 'Independent' sheet 
# -Fields:
#     - School Number ==
#         - unique id
#         - check analysis for 'Maintained' sheet.
#         - [] check whether same schools are present in the 'Maintained' sheet
#     - School Name ==
#         - name field
#         - check analysis for 'Maintained' sheet.
#         - [] check whether same schools are present in the 'Maintained' sheet
#     - LA Code ==
#         - 3 digit integer
#         - 16 distinct entries
#         - check analysis for 'Maintained' sheet.
#         - [] check whether entries are duplicated in 'Maintained' sheet
#     - Local Authority ==
#         - string
#         - 16 distinct entries
#         - [] check for 1:1 relationship with 'LA Code'
#         > provisional table, including fields for 'LA Code' and 'Local Authority' (assuming 1:1 relationship between the two).
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

# End of analysis for 'Independent' spreadsheet.


# Analysis of 'PRU' sheet 
# -Fields:
#     - School Number ==
#         - unique id
#         - check analysis for 'Maintained' sheet.
#         - [] check whether same schools are present in the 'Maintained' sheet
#     - School Name ==
#         - name field
#         - check analysis for 'Maintained' sheet.
#         - [] check whether same schools are present in the 'Maintained' sheet
#     - LA Code ==
#         - 3 digit integer
#         - 18 distinct entries
#         - check analysis for 'Maintained' sheet.
#         - [] check whether entries are duplicated in 'Maintained' sheet
#     - Local Authority ==
#         - string
#         - 18 distinct entries
#         - [] check for 1:1 relationship with 'LA Code'
#         > provisional table, including fields for 'LA Code' and 'Local Authority' (assuming 1:1 relationship between the two).
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

# End of analysis for 'PRU' sheet.


# Meta Analysis of all sheets:
From Index:
- 'List' appears to be the master level for 'School Type'/'Sector'. Appears to be the level above 'Sector', which is the level above 'School Type'
    - Hierachy:
        - List
            - Sector
                - School Type
- Entries for 'Lists' are:
    - Maintained
    - Independent
    - PRU
- This should be a field in a register, where you combine all the schools tabs (Maintained, Independent, PRU) into one table
- [] confirm with the custodian whether this is hierachy exists
- [] make a decision whether to turn 'List' into a register, containing all sublevels (a self referential register, like allergens)


# Definitions of terms:
## Schools section of N1
- Nursery: age under 5. Primary: ages 3/4 to 10. Middle: ages 3/4 to 16/18. Secondary: ages 11 to 16/18.
- Special schools: both day and boarding, provide education for children with Special Educational Needs, who cannot be educated satisfactorily in mainstream schools.
- Maintained: Schools maintained by the local authorities.

## Puprils section of N1
- Schools’ data are derived from the Pupil Level Annual School Census returns and STATS 1 returns supplied by schools open on Census day in January each year. (Blank = new school.)

## Governance section of N1
- 'Community': Schools which are wholly owned and maintained by the local authority. The local authority is the admissions authority — it has main responsibility for deciding arrangements for admitting pupils.
- 'Voluntary aided': These are established by voluntary bodies, mainly the religious denominations, but are maintained by the LAs. The admission authority of a voluntary aided school is the governing body.
- 'Voluntary controlled': These are established by voluntary bodies, mainly the religious denominations, but are maintained by the LAs. The admission authority of a voluntary controlled school is the LA.
- 'Foundation': Foundation schools have more freedom than community schools to manage their school and decide on their own admissions. Funding comes from the local authority.
- 'Not Applicable': NA

## Welsh medium type
- 'Welsh medium': Welsh is the day to day language of the school. Welsh is used as the language of communication with the pupils and for the school’s administration. The school communicates with parents in both languages.
- 'Dual Stream' (under primary school only in N1): Both Welsh and English are used in the day to day business of the school. The language of communication with the pupils is determined by the nature of the curricular provision, but in some schools high priority is given to creating a Welsh-language ethos throughout the school. The school communicates with parents in both languages.
- 'Transitional' (under primary school only in N1): Welsh is the language of the day to day business of the school. A high priority is given to creating a Welsh ethos. The school communicates with parents in both languages.
- 'English with significant Welsh': The day to day language or languages of the school are determined by the school’s linguistic context. Both languages are used as languages of communication with the pupils and for the school’s administration. A high priority is given to creating a Welsh ethos. The school communicates with parents in both languages.
- 'English medium': English is the language of the day to day business of the school, but some Welsh is also used as a language of communication with the pupils with the aim of improving their capacity to use everyday Welsh. The school communicates with parents either in English or in both languages.
- 'Bilingual (Category A)': At least 80% of subjects apart from English and Welsh are taught only through the medium of Welsh to all pupils. One or two subjects are taught to some pupils in English or in both languages.
- 'Bilingual (Category B)': At least 80% of subjects (excluding Welsh and English) are taught through the medium of Welsh but are also taught through the medium of English.
- 'Bilingual (Category C)': 50-79% of subjects (excluding Welsh and English) are taught through the medium of Welsh but are also taught through the medium of English.
- 'Bilingual (Category Ch)': All subjects, except Welsh and English taught to all pupils using both languages.

## Education consortia - There are four formal Education consortia in Wales covering:
- North Wales 
    - Flintshire, 
    - Conwy, 
    - Wrexham,
    - Gwynedd, 
    - Isle of Anglesey,
    - Denbighshire
- South West and Mid Wales 
    - Swansea,
    - Neath Port Talbot,
    - Carmarthenshire,
    - Pembrokeshire,
    - Powys,
    - Ceredigion
- Central South Wales 
    - Bridgend,
    - Cardiff,
    - Merthyr Tydfil,
    - Rhondda Cynon Taf,
    - Vale of Glamorgan
- South East Wales 
    - Caerphilly,
    - Monmouthshire,
    - Newport,
    - Blaenau Gwent,
    - Torfaen
