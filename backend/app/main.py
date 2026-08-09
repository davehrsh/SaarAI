import logging

from fastapi import FastAPI

from app.routers.analysis import router as analysis_router
from app.routers.health import router as health_router

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

app = FastAPI(
    title="SaarAI API",
    description="AI-powered food ingredient analyzer",
    version="1.0.0",
)

app.include_router(analysis_router)
app.include_router(health_router)

@app.get("/")
async def root():
    return {
    "name": "SaarAI API",
    "version": "1.0.0",
    "status": "online"
}