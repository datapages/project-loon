import redivis

query = """
{{query}}
"""

workflow = redivis.user("mikabr").workflow("project_loon")
df = workflow.query.to_pandas_dataframe(max_results = 100) # remove max as needed
