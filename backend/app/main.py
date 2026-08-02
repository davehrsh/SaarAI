from fastapi import FastAPI

app = FastAPI(
    title="SaarAI API",
    description="AI-powered food ingredient analyzer",
    version="1.0.0",
)


@app.get("/")
async def root():
    return {
        "message": "Welcome to SaarAI 🚀"
    }