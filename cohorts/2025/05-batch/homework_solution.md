# Module 5 Homework

In this homework we'll put what we learned about Spark in practice.

For this homework we will be using the Yellow 2024-10 data from the official website: 

```bash
wget https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2024-10.parquet
```


## Question 1: Install Spark and PySpark

- Install Spark
- Run PySpark
- Create a local spark session
- Execute spark.version.

What's the output?

> [!NOTE]
> To install PySpark follow this [guide](https://github.com/DataTalksClub/data-engineering-zoomcamp/blob/main/05-batch/setup/pyspark.md)


## Question 2: Yellow October 2024

Read the October 2024 Yellow into a Spark Dataframe.

Repartition the Dataframe to 4 partitions and save it to parquet.

What is the average size of the Parquet (ending with .parquet extension) Files that were created (in MB)? Select the answer which most closely matches.

- 6MB
- 25MB x
- 75MB
- 100MB


## Question 3: Count records 

How many taxi trips were there on the 15th of October?

Consider only trips that started on the 15th of October.

```python
spark.sql("""
SELECT
    date_trunc('day', tpep_pickup_datetime) AS day,
    count(1)
FROM
    yellow
GROUP BY 
    day
""").show()

```


- 85,567
- 105,567
- 125,567 x
- 145,567


## Question 4: Longest trip

What is the length of the longest trip in the dataset in hours?

```python
spark.sql("""
SELECT
    DATEDIFF(hour, tpep_pickup_datetime, tpep_dropoff_datetime) as duration
FROM
    yellow
ORDER by
    duration desc
""").show()
```

- 122
- 142
- 162 x
- 182


## Question 5: User Interface

Spark’s User Interface which shows the application's dashboard runs on which local port?

- 80
- 443
- 4040 x
- 8080



## Question 6: Least frequent pickup location zone

Load the zone lookup data into a temp view in Spark:

```bash
wget https://d37ci6vzurychx.cloudfront.net/misc/taxi_zone_lookup.csv
```

Using the zone lookup data and the Yellow October 2024 data, what is the name of the LEAST frequent pickup location Zone?

```python
df_zones = spark.read \
    .option("header", "true") \
    .csv('taxi_zone_lookup.csv')

df_result = df_yellow.join(df_zones, df_yellow.PULocationID == df_zones.LocationID)
df_result.registerTempTable('result')

#Using the zone lookup data and the Yellow October 2024 data, what is the name of the LEAST frequent pickup location Zone?
spark.sql("""
SELECT
    zone,
    count(1) as freq
FROM
    result
GROUP BY 
    zone
ORDER BY
    freq asc
""").show()
```

- Governor's Island/Ellis Island/Liberty Island x
- Arden Heights
- Rikers Island
- Jamaica Bay


## Submitting the solutions

- Form for submitting: https://courses.datatalks.club/de-zoomcamp-2025/homework/hw5
- Deadline: See the website
