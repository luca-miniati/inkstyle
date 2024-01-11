import os
from dotenv import load_dotenv
from supabase import create_client

load_dotenv()

url = os.environ.get("SUPABASE_URL")
key = os.environ.get("SUPABASE_SERVILE_ROLE")

supabase = create_client(url, key)

response = supabase.table("users").select("*").execute()
