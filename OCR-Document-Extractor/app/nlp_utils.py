import spacy

nlp = spacy.load("en_core_web_sm")

def extract_entities(text):
    doc = nlp(text)
    return {
        "PERSON": [ent.text for ent in doc.ents if ent.label_ == "PERSON"],
        "ORG": [ent.text for ent in doc.ents if ent.label_ == "ORG"],
        "DATE": [ent.text for ent in doc.ents if ent.label_ == "DATE"],
        "GPE": [ent.text for ent in doc.ents if ent.label_ == "GPE"],
    }
