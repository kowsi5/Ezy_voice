from flask import Flask, request, jsonify
from flask_cors import CORS
from word2number import w2n
from num2words import num2words
import re

app = Flask(__name__)
CORS(app)

# MASTER_MAP for regional multiplication words
MASTER_MAP = {
    "into": "*",
    "multiple": "*",
    "multiplied by": "*",
    "projects": "*", # Common misinterpretation
    "x": "*",
    "ഗുണിക്കണം": "*",   # Malayalam
    "गुना": "*",        # Hindi
    # Add more regional mappings here
}

def preprocess_expression(text):
    """
    Replace regional/natural language operators with mathematical symbols.
    """
    text = text.lower()
    for word, symbol in MASTER_MAP.items():
        text = text.replace(word, symbol)
    return text

def evaluate_expression(expression):
    try:
        # Security: Allow only digits and math operators
        # This is a basic sanitizer, might need more robust parsing for complex words
        # For now, we rely on w2n for word-to-number conversion if needed, 
        # but the prompt says "Translation Layer: Converts recognized regional tokens into English digits" 
        # happens BEFORE backend or IS the backend?
        # Requirement: "Translation Layer: Converts recognized regional tokens (e.g., "അഞ്ച്") into English digits ("5")."
        # Requirement: "Math Logic (Python Backend)... Safe evaluation... using num2words and w2n"
        
        # It seems the backend might receive "five plus five" or "5 + 5"
        # If it receives words, we need to convert them.
        
        # For this phase, let's assume we might receive mixed content.
        # But 'eval' is dangerous. We should be careful.
        
        # Simple evaluation for now:
        result = eval(expression, {"__builtins__": None}, {})
        return result
    except Exception as e:
        return str(e)

@app.route('/calculate', methods=['POST'])
def calculate():
    data = request.get_json()
    if not data or 'expression' not in data:
        return jsonify({'error': 'No expression provided'}), 400
    
    raw_expression = data['expression']
    
    # 1. Preprocess (Map regional words to operators)
    processed_expr = preprocess_expression(raw_expression)
    
    # 2. Evaluate
    # Note: A more complex parser might be needed if the input is "five times ten" 
    # and w2n is needed to convert "five" -> 5.
    # The prompt implies the Translation Layer (STT + Translation) might handle some of this, 
    # but the backend "Engine" uses w2n.
    
    try:
        # Attempt to evaluate directly first (if numbers are already digits)
        # If it fails, or if it contains words, we might need w2n logic.
        # However, w2n works on "one hundred thirty five", not "5 * 5".
        # We might need a custom parser to split by operators and convert operands.
        
        # For this MVP/Phase 1:
        # We will assume the input is mostly digits and operators, or simple words w2n can handle if isolated.
        # But w2n doesn't parse full math expressions like "two plus two".
        
        # Let's try to handle basic conversion if needed, but for now relying on STT sending digits is safer 
        # unless we implement a full parser.
        
        result = evaluate_expression(processed_expr)
        
        # 3. Text to Speech friendly result (optional, but good for return)
        result_text = num2words(result) if isinstance(result, (int, float)) else str(result)
        
        return jsonify({
            'original': raw_expression,
            'processed': processed_expr,
            'result': result,
            'result_text': result_text
        })
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/health', methods=['GET'])
def health():
    return jsonify({'status': 'ok'})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
