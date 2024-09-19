
# Web Scraping and Analysis of Journal Articles using R

## Overview

This project focuses on web scraping journal article data related to immunity and aging using R. The data is extracted, cleaned, pre-processed, analyzed, and visualized to provide insights into the distribution of published articles over time. The project demonstrates the use of R for data scraping, cleaning, and visualization, providing a practical application of these techniques in the context of academic research.

## Project Structure

- **R Script**: Contains the R code used to perform web scraping, data cleaning, pre-processing, and visualization.
- **Data**: Includes the CSV file generated from the scraped data.
- **Presentation**: A PowerPoint presentation summarizing the project, including an introduction to web scraping, the methodology, and the results.
- **Visualization**: Contains images and plots generated during the data analysis process.

## Features

- **Web Scraping**: Uses the `rvest` package to scrape article data from multiple pages of a journal website.
- **Data Cleaning**: Involves handling missing data, outlier detection, and removing duplicates.
- **Data Pre-Processing**: Includes data transformation, feature selection, and encoding of categorical variables.
- **Data Visualization**: Utilizes `ggplot2` to create informative plots that help understand the distribution and trends in the dataset.

## Installation

To run the code and explore the analysis, you need to have R installed on your machine along with the necessary packages. You can install the required packages using the following command:

```r
install.packages(c("rvest", "httr", "xml2", "ggplot2", "writexl"))
```

## Usage

1. **Run the R Script**: The R script (`R Project.R`) scrapes the data, cleans it, and generates visualizations. You can run this script in RStudio or any R environment.
2. **View the Presentation**: The PowerPoint presentation (`R Project.pptx`) provides a visual summary of the project, including key findings and challenges faced during the scraping and analysis process.
3. **Analyze the Data**: The `Articles.csv` file contains the scraped data, which you can further analyze or use in other projects.
4. **Explore the Visualizations**: The `Visualization.png` file showcases a bar chart representing the distribution of published articles by year, illustrating the trends in research output over time.

## Results

The analysis reveals an increasing trend in the number of articles published over the years, particularly in recent years, indicating growing interest and research in the fields of immunity and aging.

## Challenges

Some of the challenges faced during the project include:
- Extracting keywords from the HTML code of the journal pages.
- Handling the large volume of data across multiple pages.
- Ensuring the accuracy and reliability of the data through rigorous cleaning processes.

## Contributors

- Srikar Choudary Katta
- Palvai Tharun Reddy
- Balaji Kolusu

## References

- [Web Scraping with R: rvest package](https://statsandr.com/blog/web-scraping-in-r/)
- [Data Cleaning and Preprocessing with R](https://www.tutorialspoint.com/data-cleaning-and-preprocessing-with-r)
- [Data Visualization in R](https://www.geeksforgeeks.org/data-visualization-in-r/)

