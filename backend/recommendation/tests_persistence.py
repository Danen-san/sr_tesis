from django.test import TransactionTestCase
from django.db import transaction, IntegrityError
from recommendation.models import User, StudentProfile, LearningObject, Recommendation

class BackendPersistenceTests(TransactionTestCase):

    def setUp(self):
        """Configuración inicial de objetos persistentes."""
        self.user = User.objects.create_user(username="test_user", role="student")
        self.profile = StudentProfile.objects.create(user=self.user, academic_risk=0.3)
        self.lo = LearningObject.objects.create(
            title="Variables Globales",
            description="Uso de variables",
            topic="Variables",
            difficulty="easy"
        )

    def test_operaciones_crud_exitosas(self):
        """Validación del ciclo de vida CRUD completo en PostgreSQL."""
        # 1. Create & Read
        rec = Recommendation.objects.create(
            student=self.profile,
            learning_object=self.lo,
            confidence_score=0.95
        )
        self.assertIsNotNone(rec.id)

        # 2. Update
        rec.is_consumed = True
        rec.feedback_rating = 5
        rec.save()
        
        rec_actualizada = Recommendation.objects.get(id=rec.id)
        self.assertTrue(rec_actualizada.is_consumed)
        self.assertEqual(rec_actualizada.feedback_rating, 5)

        # 3. Delete
        id_temp = rec.id
        rec.delete()
        with self.assertRaises(Recommendation.DoesNotExist):
            Recommendation.objects.get(id=id_temp)

    def test_atomicidad_y_rollback_ante_error(self):
        """
        Simula una desconexión o fallo crítico a mitad de una transacción.
        Verifica que PostgreSQL mantenga la integridad y no deje datos huérfanos.
        """
        conteo_inicial = Recommendation.objects.count()

        try:
            with transaction.atomic():
                # Operación válida
                Recommendation.objects.create(
                    student=self.profile,
                    learning_object=self.lo,
                    confidence_score=0.88
                )
                
                # Forzamos un error de integridad (por ejemplo, insertar un objeto sin los campos obligatorios)
                # Esto simula un corte abrupto o fallo de constraints
                Recommendation.objects.create(student=None, learning_object=self.lo, confidence_score=None)
        except IntegrityError:
            # El error es capturado correctamente por el manejador de fallos
            pass

        # Verificación del Rollback: El primer registro no debe haberse guardado
        conteo_final = Recommendation.objects.count()
        self.assertEqual(
            conteo_inicial, conteo_final,
            "La base de datos quedó en un estado inconsistente. Falló el mecanismo de Rollback."
        )