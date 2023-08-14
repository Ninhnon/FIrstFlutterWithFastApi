import uvicorn
from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI(title='Ninhnon RestAPI',
              description='An API running on FastAPI + uvicorn',
              version='0.0.1')

class Profile(BaseModel):
    name: str = ""

profiles = [
    Profile(name='Ninhnon')
]

@app.get("/profiles")
async def get_profiles():
    return profiles

@app.post("/profile")
async def add_profile(profile:Profile):
    profiles.append(profile)


if __name__ == "__main__":
    uvicorn.run(app, host="localhost", port=8000)