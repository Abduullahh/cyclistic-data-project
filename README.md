# cyclistic-data-project
##### My google data anlaytics certificate capstone (track one)


# Ask

### Three questions will guide the future marketing program:
1. How do annual members and casual riders use Cyclistic bikes differently?
2. Why would casual riders buy Cyclistic annual memberships?
3. How can Cyclistic use digital media to influence casual riders to become members?

### Guiding questions
1. What is the problem you are trying to solve?
- Trying to find a new marketing strategy aimed to convert casual riders into members.
2. How can your insights drive business decisions?
- It can help the stakeholders take a data driven decision based on the insights i'm coming up with.

### Key tasks
1. Identify the business task
2. Consider key stakeholders
- Done

### Deliverable
##### A clear statement of the business task
- Got to figure how Causals and Members use Cyclistic in differently, how would degital media influence Casuals to become Members, and why would Casuals buy annual membership.


# Prepare
### Guiding questions
1. Where is your data located?
- Locally on my computer.
2. How is the data organized? 
- In tables as rows and columns.
3. Are there issues with bias or credibility in this data? Does your data ROCCC?
- There're no issues, And my data does ROCCC because it's reliable, original, current, comprehensive and cited.
4. How are you addressing licensing, privacy, security, and accessibility?
- The company that shared this data has its own license, privacy and security methods.
5. How did you verify the data’s integrity?
- By checking that each column has a consistent data type.
6. How does it help you answer your question?
- It has data of when and where the rides happened and some other data fields that's going to be helpful to analyze and gain insights from.
7. Are there any problems with the data?
- Just some station names are blanks and they are so many, other than this no there're no problems.

### Key tasks
1. Download data and store it appropriately.
2. Identify how it’s organized.
3. Sort and filter the data.
4. Determine the credibility of the data.
- Done.

### Deliverable
##### A description of all data sources used
- Used a 12 month historical data from Cyclystic (data from 2022-Feb to 2023-Jan).


# Process
### Guiding questions
1. What tools are you choosing and why?
- SQL and Tableau, because SQL is good at handling large datasets and tableau is so good for data viz.
2. Have you ensured your data’s integrity?
- Yes. My data is accurate, complete, consistent, and trusted.
3. What steps have you taken to ensure that your data is clean?
- I made sure that the data i'm working with is complete, correct and relevant to the problem i'm trynna solve.
4. How can you verify that your data is clean and ready to analyze?
-  Check the [postgresql-local.session.sql](postgres-local.session.sql) file i've added all the steps i took to get my data ready.
5. Have you documented your cleaning process so you can review and share those results?
-  Yes by using this [README](README.md) file and also the [postgresql-local.session.sql](postgres-local.session.sql) file.

### Key tasks
1. Check the data for errors.
2. Choose your tools.
3. Transform the data so you can work with it effectively.
4. Document the cleaning process.
- Done.

### Deliverable
##### Documentation of any cleaning or manipulation of data
- Refer to [postgresql-local.session.sql](postgres-local.session.sql).


# Analyze
### Guiding questions
1. How should you organize your data to perform analysis on it?
- This is done by sorting and filtering my data.
2. Has your data been properly formatted?
- Yes, all columns have consistent data type.
3. What surprises did you discover in the data?
- After i cleaned my data in the process step i found out that my data still had some things needed to be cleaned.
- The differences between Members and Casuals i found.
4. What trends or relationships did you find in the data?
- Members are more than the Casuals.
- Members use 2 types only of the rideable bikes while Casuals use 3.
- Members are more likely to use the service on the weekdays while Casuals tend more to use it on the weekends.
- Based on the hourly rides Members follow the peaks of a work day while Casuals use the service mostly in the afternoon and the early evening.
- Based on the maximum ride lengths and also the average i can conclude that Casuals use the service for longer periods of time than Members.
- Based on the monthly rides i can conclude that rides have higher records in the spring and summer, and lower records in fall and winter.
5. How will these insights help answer your business questions?
- It shows some differences between Members and Casual.

### Key tasks
1. Aggregate your data so it’s useful and accessible.
2. Organize and format your data.
3. Perform calculations.
4. Identify trends and relationships.
- Done

### Deliverable
##### A summary of your analysis
- Refer to [postgresql-local.session.sql](postgres-local.session.sql).


# Share
### Guiding questions
1. Were you able to answer the question of how annual members and casual riders use Cyclistic bikes differently?
- Yes, Answered it in the Analyze phase section.
2. What story does your data tell?
- It tells that Casuals overall uses the service for longer periods of time than Members as they use it for leisure while Members are more often to use it for a routine activity on certain times, Members use the service more during the weekdays (Monday - Friday) while Casuals use the service more on the weekends (Saturday and Sunday).
3. How do your findings relate to your original question?
- My findings show how Members and Casuals use the service differently.
4. Who is your audience? What is the best way to communicate with them?
- My audience is Lily Moreno (the director of marketing), Cyclistic marketing analytics team, and Cyclistic executive team
- The best way to communicate with them is by presenting them with the visualizations i've created.
5. Can data visualization help you share your findings?
- Yes, the core of my findings is found within the visualizations i've created.
6. Is your presentation accessible to your audience?
- Yes

### Key tasks
1. Determine the best way to share your findings.
2. Create effective data visualizations.
3. Present your findings.
4. Ensure your work is accessible.
- Done

### Deliverable
##### Supporting visualizations and key findings
- Refer to the PDFs i've uploaded in the code section.


# Act
### Guiding questions
1. What is your final conclusion based on your analysis?
- Members and Casuals use the service differently, The conclusions are stated in the Analyze and Share sections.
2. How could your team and business apply your insights?
- The insights could be applied within the marketing campaign to turn Casuals into Members.
3. What next steps would you or your stakeholders take based on your findings?
- We could do a further analysis to improve findings more if needed.
4. Is there additional data you could use to expand on your findings?
- A data displays the climate would be so helpful to do further analysis and improve findings. 

### Key tasks
1. Create your portfolio.
2. Add your case study.
3. Practice presenting your case study to a friend or family member.
- Done

### Deliverable
##### Your top three recommendations based on your analysis
- Make ads on how bikes help people get to their work and how it would be helpful for our planet to lower the usage of vehicles and replace it with the bikes.
- Make some benifits during the warm months (spring and summer), Like coupons for free single rides or some discounts on the annual memberships.
- Make a discount offer on the annual membership for the new subscribers, this would attract more people to buy memberships.