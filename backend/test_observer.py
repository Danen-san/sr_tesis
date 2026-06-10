import asyncio
import websockets
import json

async def monitor_alerts():
    uri = "ws://localhost:8000/ws/teacher_dashboard/"
    print(f"--- Iniciando Observador (Profesor) en {uri} ---")
    
    try:
        async with websockets.connect(uri) as websocket:
            print(">>> [OK] Conectado al servidor. Esperando alertas...")
            
            while True:
                # El observador queda en espera activa de mensajes del sujeto
                message = await websocket.recv()
                data = json.loads(message)
                print(f"\n>>> [ALERTA RECIBIDA] <<<")
                print(json.dumps(data, indent=4))
                
    except Exception as e:
        print(f"\n>>> [ERROR] No se pudo conectar: {e}")
        print("Asegúrate de que Daphne esté corriendo: 'daphne core.asgi:application'")

if __name__ == "__main__":
    try:
        asyncio.run(monitor_alerts())
    except KeyboardInterrupt:
        print("\nMonitor detenido por el usuario.")