# backend/recommendation/consumers.py
import json
from channels.generic.websocket import AsyncWebsocketConsumer

class TeacherDashboardController(AsyncWebsocketConsumer):
    """
    Patrón Observer: Actúa como el Observador. 
    Mantiene la conexión WebSocket con el frontend del panel docente.
    """
    async def connect(self):
        # Aceptamos la conexión sin condiciones previas de autenticación para probar
        await self.accept()
        # Añadimos al grupo de forma simple
        await self.channel_layer.group_add("teacher_alerts", self.channel_name)
        print("¡Conexión aceptada!")

    async def disconnect(self, close_code):
        await self.channel_layer.group_discard("teacher_alerts", self.channel_name)

    async def risk_alert(self, event):
        # Enviamos el mensaje al cliente
        await self.send(text_data=json.dumps(event))