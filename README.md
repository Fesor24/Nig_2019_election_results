# Nigeria's 2019 Presidential Election Results

As Nigeria prepare for her 8th General elections, I decided to take it back and refresh my memory on how the last elections played out. In this analysis primary focus is placed on the top two (2) political parties as all the states in the Nigerian Federation were won by either of the parties. While the data collected includes the votes count distribution of the top five (5) political parties in each states, visualization of the analysis was only in respect of the top two (2) candidates because of the reason stated above. Another reason why this was a project I did is because I do have interest in Politics and the nature of my undergraduate degree which is Law has a kind of bearing with politics, governance. You can't totally separate Law and Politics. It is somewhat intertwined.

## Data Collection

The dataset used for analysis was obtained from [BBC](https://www.bbc.co.uk/news/resources/idt-f0b25208-4a1d-4068-a204-940cbe88d1d3). I used Selenium which is a Python Library Package to scrape data from the website. My choice of selenium over BeautifulSoup, which is more beginner friendly, to scrape the website was because the website has a dynamic dropdown which contains all the states in Nigeria and the election results for that state. In other words, only a single state can be selected from the dropdown and the election results of that state will be displayed. I felt more comfortable using Selenium. The csv files will be included in this repository

## Data Wrangling
With the aid of Python's string functions and Pandas Library Package in Python, I was able to clean the data and prepare it to be imported to MySql for analysis.

## Data Analysis

After scraping the data and converting it to dataframes, I imported the csv files to MySql for further analysis. Using intermediate to advanced SQL functions like Windows function, Joins, CASE statement and so on, I was able to analyze the datasets and also prepare it for data visualization on Tableau

## Data Visualization
After analysis with MySql, I imported the csv files to Tableau for visualization. I created a dashboard which contains the map of Nigeria showing, among other viosuals, different states won by each political party, an horizontal bar chart showing the total votes of the top 2 political parties by region, an horizontal bar chart showing the total votes in all states of the top 2 political parties, a stacked column chart showing the distribution of votes across the various states between the top 2 parties and so on. With the aid of this dashoard, on a glance you can grasp a lot of information on how the last general elections played out.

[Check out the Interactive election result dashboard on Tableau](https://public.tableau.com/views/Nigeria2019PresidentialElectionResults/Nigerias2019PresidentialElections?:language=en-US&:display_count=n&:origin=viz_share_link) 

![](img/Nigeria's%202019%20Presidential%20Elections.png)


# Thank you

