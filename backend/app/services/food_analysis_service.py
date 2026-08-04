from fastapi import UploadFile


class FoodAnalysisService:

    async def analyze(self, file: UploadFile):

        image_bytes = await file.read()

        return {
            "filename": file.filename,
            "content_type": file.content_type,
            "size": len(image_bytes)
        }