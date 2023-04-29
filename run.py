import requests
import pprint
import pandas as pd
import boto3
from io import StringIO

def remove (obj):
    obj.pop('contents')
    obj.pop('id')
    obj.pop('levels')
    obj.pop('refs')
    obj.pop('tags')
    obj.pop('type')
    obj.pop('model_type')
    obj.pop('short_name')
    obj["locations"]= obj["locations"][0]["name"]
    obj["categories"] = obj["categories"][0]["name"]
# Example API endpoint
url = 'https://www.themuse.com/api/public/jobs?page=50'

# Make a GET request to the API endpoint
response = requests.get(url)

# “company name”
# “locations”,
# “job name”,
# “job type”,
# “publication date”,

# Convert the response to a dictionary
json_list = response.json()["results"]

for key in json_list:
    remove(key)

# Normalize the JSON objects
data = pd.json_normalize(json_list)

# Convert the normalized data to a DataFrame

# “company name”
# “locations”,
# “job name”,
# “job type”,
# “publication date”,
df = pd.DataFrame(data)

# remove and rename columns
df = df.rename(columns={'name': 'job name', 'categories': 'job type', 'company.name': 'company name'})
df = df.drop("company.id",axis=1)
df = df.drop("company.short_name", axis=1)


df.to_csv('job.csv', index=False)

# # Save the DataFrame to a CSV in memory
csv_buffer = StringIO()
df.to_csv(csv_buffer, index=False)

# # Define the S3 bucket name and the file key
bucket_name = 'weclouds3example'
file_key = '/'

# # Initialize the S3 client
s3_client = boto3.client('s3')


# # Upload the CSV to the S3 bucket
s3_client.put_object(Bucket=bucket_name, Key=file_key, Body=csv_buffer.getvalue())

print("CSV file uploaded to S3")


