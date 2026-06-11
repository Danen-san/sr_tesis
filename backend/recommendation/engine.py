import pandas as pd
from sklearn.metrics.pairwise import cosine_similarity
from sklearn.feature_extraction.text import TfidfVectorizer

class HybridRecommendationEngine:
    """
    Implementación del Patrón Singleton para el motor de Inteligencia Artificial.
    Evita la duplicación de instancias en memoria durante peticiones simultáneas.
    """
    _instance = None

    # El método __new__ intercepta la creación del objeto.
    def __new__(cls, *args, **kwargs):
        if not cls._instance:
            cls._instance = super(HybridRecommendationEngine, cls).__new__(cls, *args, **kwargs)
            # Aquí podrías cargar modelos pesados pre-entrenados una sola vez
        return cls._instance

    def get_recommendations_for_student(self, student_profile, all_learning_objects):
        df = pd.DataFrame(all_learning_objects)
        if df.empty:
            return []
            
        tfidf = TfidfVectorizer(stop_words='english')
        tfidf_matrix = tfidf.fit_transform(df['topic'])
        
        weak_topics_text = " ".join(student_profile['weak_topics']) if student_profile['weak_topics'] else ""
        if not weak_topics_text:
            return df.head(3).to_dict('records') # Retorno por defecto si no hay debilidades
            
        student_vector = tfidf.transform([weak_topics_text])
        cosine_sim = cosine_similarity(student_vector, tfidf_matrix).flatten()
        df['score'] = cosine_sim
        
        if student_profile['current_risk'] > 0.7:
            df.loc[df['difficulty'] == 'hard', 'score'] *= 0.5
            
        recommendations = df.sort_values(by='score', ascending=False).head(3)
        return recommendations.to_dict('records')