from fastapi import FastAPI

from app.routers.analysis import router as analysis_router

app = FastAPI(
    title="SaarAI API",
    description="AI-powered food ingredient analyzer",
    version="1.0.0",
)

app.include_router(analysis_router)


@app.get("/")
async def root():
    return {
        "message": "Welcome to SaarAI 🚀"
    }