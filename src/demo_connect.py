# src/demo_connect.py
from databricks.connect.session import DatabricksSession

spark = DatabricksSession.builder.getOrCreate()

df = spark.range(10)
df2 = df.selectExpr("id", "id * 2 as n2")
print("Cluster:", spark.conf.get("spark.databricks.clusterUsageTags.clusterName"))
print("Count:", df2.count())
print(df2.limit(5).toPandas())
