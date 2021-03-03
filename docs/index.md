*Megan Rahrig*  
*2/27/21*  
*IT Foundations of Databases and SQL Programming*  
*Assignment 07*  

 
# SQL Functions
## Introduction
Functions are a useful tool for reporting on and analyzing data in SQL server. In addition to using built-in functions, one can also create a custom function to serve their needs. This is known as a user defined function (UDF). 

Below, we’ll explore when to utilize a UDF and the various types of UDFs including scalar, inline, and multi-statement functions. 
When Would You Use a SQL UDF?

## What is a UDF?
UDF stands for “user defined function”. Like the name implies, UDFs are custom functions that you can create. UDFs allow you to return things like a single datapoint or a table. Once created, you can save and use this custom function repeatedly.

## When to Use a UDF
UDFs are beneficial for a variety of reasons. Not only do they allow a user to create a custom function that can be saved and reused, but they can also be used for reporting and ETL processing.

### Reporting
UDFs allow you to create functions that return readable, usable data that you and your team can analyze. One example is using a custom function to return a table that compares data month over month along with the percentage difference (perhaps as a KPI) using a Lag function and a mathematical function. (https://www.youtube.com/watch?v=BWw5YUv49c4&list=PLfycUyp06LG_8aYt19coVTwUDr2CaaSY5&index=3, 2021) (External site)

### ETL Processing
You can create a function to edit data in tables. For example, you could trim or parse data in a table to make it easier to read or use.
(https://www.youtube.com/watch?v=URSjRbN1rCQ&list=PLfycUyp06LG_8aYt19coVTwUDr2CaaSY5&index=4, 2021) (External site)

## The Differences Between Scalar, Inline, and Multi-Statement Functions

### Scalar Functions
Scalar functions return a single value. It’s recommended that you include the “dbo” prefix in order for your function to reliably work. Unlike with inline and multi-statement functions, the datatype that it must return may include “float”, “int”, etc. This is because a scalar function only returns one datapoint – not a table.

### Inline Functions
Inline functions are a type of table-valued functions (in contrast to scalar functions which only return single datapoints!). These are “simple” functions because you only need to define what data you want returned and their datatype. This is different from the additional parameters you need to define in a multi-statement function. 

While you do not need to use Begin and End with scalar functions, you do need to use these in table-valued functions like the inline function and the multi-statement function that I’ll discuss more below.

### Multi-Statement Functions
Similar to inline functions, multi-statement functions are a type of table-valued functions. However, unlike inline functions, multi-statement functions only return a table of data after some additional processing. This processing can include defining column names and datatypes after “Returns” and before “As”. See an example below in figure 1. 

You can also include multiple Select statements in multi-statement functions, hence the name!

![Figure1](./docs/Screen%20Shot%202021-02-28%20at%204.18.04%20PM.png "Figure 1")  

*Figure 1. example of multi-statement function*

(https://www.wiseowl.co.uk/blog/s347/multi-statement.htm, 2021) (External site)

## Conclusion
Knowing how to use SQL server to retrieve and edit data is great, but knowing how to use it to analyze and report on data will open new doors for you and your company. Use UDFs to return and analyze key performance indicators for your company through scalar functions (which return single datapoints), inline functions (which return simple tables), or multi-statement functions (which allow for more complex processing to return tables).



