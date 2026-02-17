
from flask import Flask, request, jsonify
from flask_cors import CORS
from deep_translator import GoogleTranslator
from word2number import w2n
import inflect
import re

app = Flask(__name__)
CORS(app)
p = inflect.engine()

# EXPANDED MASTER MAP for Hindi & Tamil (Prevents Calculation Error)
# UPDATE YOUR MASTER_MAP WITH THESE VALUES
MASTER_MAP = {
    # Tamil & Hindi (Keep as you have or use 'plus', 'minus', etc.)
    "கூட்டல்": "plus", "கழித்தல்": "minus", "பெருக்கல்": "times", "வகுத்தல்": "divided by",
    "जोड़": "plus", "घटाव": "minus", "गुणा": "times", "भाग": "divided by",

    # MALAYALAM (ml) - Changed to Keywords
    "കൂട്ടണം": "plus", "കൂട്ടുക": "plus",
    "കുറയ്ക്കണം": "minus", "കുറയ്ക്കുക": "minus",
    "ഗുണിക്കണം": "times", "ഗുണനം": "times",  # Fix: Use 'times'
    "ഹരിക്കണം": "divided by", "ഹരിക്കുക": "divided by",

    # KANNADA (kn) - Changed to Keywords
    "ಕೂಡಿಸು": "plus", "ಸಂಕಲನ": "plus",
    "ಕಳೆ": "minus", "ವ್ಯವಕಲನ": "minus",
    "ಗುಣಿಸು": "times", "ಗುಣಾಕಾರ": "times",  # Fix: Use 'times'
    "ಭಾಗಿಸು": "divided by",

    # TELUGU (te) - Changed to Keywords
    "ప్లస్": "plus", "కూడిక": "plus",
    "మైనస్": "minus", "తీసివేత": "minus",
    "గుణకారం": "times", "హెచ్చించు": "times",  # Fix: Use 'times'
    "భాగహారం": "divided by", "భాగించు": "divided by",

    "into": "times",
    "multiple": "times"
}


def clean_and_eval(expr):
    # Remove everything except numbers and math symbols
    expr = re.sub(r'[^0-9+\-*/.**]', '', expr)
    try:
        return eval(expr, {"__builtins__": None}, {})
    except:
        return None


@app.route("/calculate", methods=["POST"])
def calculate():
    data = request.json
    query = data.get("query", "").lower()
    lang_full = data.get("lang", "ta-IN")
    base_lang = lang_full.split('-')[0]

    try:
        # 1. Replace local script math words with English keywords
        for key, val in MASTER_MAP.items():
            query = query.replace(key, val)

        # 2. Translate only the remaining number words to English
        translated = GoogleTranslator(source='auto', target='en').translate(query).lower()

        # 3. Standardize math syntax
        # 3. Standardize math syntax (FIXED: replaced "t" with "times")
        processed = translated.replace("plus", "+") \
            .replace("minus", "-") \
            .replace("multiplied by", "*") \
            .replace("multiply", "*") \
            .replace("times", "*") \
            .replace("into", "*") \
            .replace("multiple", "*") \
            .replace("divided by", "/") \
            .replace("divide", "/") \
            .replace(" x ", "*")

        # 4. Convert words like "ten" to "10"
        # We use regex to find words and symbols separately
        tokens = re.findall(r'[a-zA-Z]+|[0-9]+|[\+\-\*\/\.]+', processed)
        expr_list = []
        for t in tokens:
            try:
                # Try converting "ten" -> "10"
                num = w2n.word_to_num(t)
                expr_list.append(str(num))
            except:
                # If it's a symbol like "+" or "*", keep it
                expr_list.append(t)

        final_expr = "".join(expr_list)
        # processed = translated.replace("plus", "+").replace("minus", "-")\
        #                       .replace("t", "*").replace("multiply", "*")\
        #                       .replace("multiplied by", "*").replace("divided by", "/")\
        #                       .replace("divide", "/").replace("into", "*")\
        #                       .replace(" x ", "*")

        # # 4. Convert "two" -> "2"
        # tokens = re.findall(r'[a-zA-Z0-9+\-*/.**]+', processed)
        # expr_list = []
        # for t in tokens:
        #     try:
        #         expr_list.append(str(w2n.word_to_num(t)))
        #     except:
        #         expr_list.append(t)

        # final_expr = "".join(expr_list)

        # 5. Execute Math
        result = clean_and_eval(final_expr)
        if result is None: return jsonify({"error": "Invalid Math"}), 400

        # 6. Convert Result: 10 -> "ten" -> "பத்து" / "दस"
        res_clean = int(result) if float(result).is_integer() else round(result, 2)
        eng_words = p.number_to_words(res_clean)
        local_words = GoogleTranslator(source='en', target=base_lang).translate(eng_words)

        return jsonify({
            "result_number": str(res_clean),
            "result_words": local_words
        })

    except Exception as e:
        return jsonify({"error": str(e)}), 500


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)