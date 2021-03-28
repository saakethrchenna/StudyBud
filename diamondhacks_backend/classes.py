from pydantic import BaseModel


class similarity_query(BaseModel):
    input: str
    target: str
