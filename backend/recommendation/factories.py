from abc import ABC, abstractmethod

# 1. Interfaz Abstracta Común
class LearningResource(ABC):
    def __init__(self, learning_object):
        self.data = learning_object

    @abstractmethod
    def get_render_metadata(self):
        """Define cómo se debe procesar este recurso en el frontend"""
        pass

# 2. Subclases Concretas
class VideoResource(LearningResource):
    def get_render_metadata(self):
        return {
            "type": "video",
            "player_config": "autoplay, subtitles",
            "content": self.data.content_url
        }

class TextResource(LearningResource):
    def get_render_metadata(self):
        return {
            "type": "text",
            "reading_time_minutes": len(self.data.description) // 200,
            "content": self.data.description
        }

class CodeResource(LearningResource):
    def get_render_metadata(self):
        return {
            "type": "interactive_code",
            "compiler_language": "python",
            "snippet": self.data.content_url
        }

# 3. La Clase Fábrica
class ResourceFactory:
    @staticmethod
    def create_resource(learning_object) -> LearningResource:
        """Encapsula la creación de la instancia correspondiente"""
        resource_mapping = {
            'video': VideoResource,
            'text': TextResource,
            'code': CodeResource,
        }
        
        # Instancia polimórficamente la clase correcta sin usar estructuras if/else complejas
        resource_class = resource_mapping.get(learning_object.resource_type, TextResource)
        return resource_class(learning_object)