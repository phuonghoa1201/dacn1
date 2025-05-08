# -*- coding: utf-8 -*-


# pip install nltk spacy transformers flask torch

# pip install pymongo

import nltk
# nltk.download('punkt')
from flask import Flask, request, jsonify
from nltk.chat.util import Chat, reflections
from pymongo import MongoClient

import threading
import re

# Khởi tạo Flask app
app = Flask(__name__)

# Kết nối với MongoDB
client = MongoClient('mongodb+srv://anhngocthiduong:dacn123@cluster0.atjpxe0.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0')  # Thay đổi URI nếu cần
db = client['test']  # Tên database
collection = db['products']  # Tên collection




# Hàm truy vấn sản phẩm
def query_products(keyword):
    query = {
        '$or': [
            {'category': {'$regex': keyword, '$options': 'i'}},
            {'description': {'$regex': keyword, '$options': 'i'}}
        ]
    }
    products = collection.find(query)
    return list(products)

# Chạy hàm kiểm tra
if __name__ == "__main__":
    products = query_products('Mobiles')  # Thay '67fcef0c5c6d12218f03000f' bằng 'áo'
    print("Kết quả tìm kiếm:")
    for product in products:
        print(product)

# Danh sách từ khóa cứng (thay cho keywords_collection)
keywords = [
    'mobiles', 'laptops', 'tablets', 'headphones', 'watches', 'mouse',
    'iphone', 'samsung', 'macbook', 'ipad', 'airpods', 'sony'
]

# Hàm lấy danh mục từ products_collection (dùng cho gợi ý)
def get_categories():
    categories = collection.distinct('category')
    return categories if categories else ['mobiles', 'laptops', 'tablets', 'headphones', 'watches', 'mouse']

# Hàm xử lý đầu vào để lấy từ khóa
def extract_keyword(user_input):
    stop_words = ['tôi', 'muốn', 'mua', 'cái', 'một', 'cho', 'với', 'giá', 'khoảng']
    # Hỗ trợ đơn vị giá (triệu/trieu)
    match = re.search(r'(\d+)\s*(triệu|trieu)', user_input, re.IGNORECASE)
    if match:
        return str(int(match.group(1)) * 1000000)

    words = user_input.lower().split()
    for word in words:
        if word not in stop_words:
            return word
    cleaned_input = ' '.join(word for word in words if word not in stop_words)
    return cleaned_input if cleaned_input else user_input

# Hàm truy vấn sản phẩm theo từ khóa
def query_products(keyword):
    query = {'$or': [
        {'name': {'$regex': keyword, '$options': 'i'}},  # Tìm trong name
        {'category': {'$regex': keyword, '$options': 'i'}},  # Tìm trong category
        {'description': {'$regex': keyword, '$options': 'i'}},  # Tìm trong description
    ], 'quantity': {'$gt': 0}}  # Chỉ lấy sản phẩm còn hàng

    # Nếu từ khóa là số, tìm trong khoảng giá (±10%)
    try:
        price_value = float(keyword)
        query['$or'].append({'price': {'$gte': price_value * 0.9, '$lte': price_value * 1.1}})
    except ValueError:
        pass

    products = collection.find(query)
    return list(products)

# Hàm xử lý đầu vào và trả về gợi ý
def get_recommendations(user_input):
    keyword = extract_keyword(user_input)

    products = query_products(keyword)

    if not products:
        categories = get_categories()
        # return f"Hmm, không tìm thấy sản phẩm nào phù hợp với '{keyword}' cả. 😅 Bạn muốn thử tìm {', '.join(categories).lower()} không?"
        return f"Hmm, bạn có muốn thử tìm {', '.join(categories).lower()} không?"

    response = f"Tuyệt! Dưới đây là những sản phẩm phù hợp với '{keyword}':\n"
    for product in products:
        response += f"- {product['name']} ({product['category']}): {product['description']}\n"
        response += f"  Giá: {product['price']:,} VNĐ\n"
        if product.get('images'):
            response += f"  Xem hình ảnh: {product['images'][0]}\n"
        response += f"  Còn lại: {product['quantity']} sản phẩm\n"
        if product.get('ratings'):
            avg_rating = sum(r['rating'] for r in product['ratings']) / len(product['ratings'])
            response += f"  Đánh giá: {avg_rating:.1f}/5\n"
        response += "\n"
    response += "Bạn muốn tìm thêm gì nữa không? 😊"
    return response

# Cách 1: Xóa route cụ thể (tốt nhất)
if 'handle_chat' in app.view_functions:
    del app.view_functions['handle_chat']
# Route API để tìm kiếm sản phẩm
@app.route('/chat-api', methods=['POST'])
def handle_chat():
    try:
        data = request.get_json()
        if not data or 'message' not in data:
            return jsonify({'error': 'Vui lòng gửi message trong body JSON'}), 400

        user_input = data['message']
        if not isinstance(user_input, str) or not user_input.strip():
            return jsonify({'error': 'Message phải là chuỗi không rỗng'}), 400

        keyword = extract_keyword(user_input)
        products = query_products(keyword)

        if not products:
            categories = get_categories()
            return jsonify({
                'message': f"Hmm, bạn có muốn thử tìm {', '.join(categories).lower()} không?",
                'type': 'suggestions',
                'suggestions': categories
            })

        # Nếu có sản phẩm, trả về danh sách
        result = []
        for product in products:
            result.append({
                'name': product['name'],
                'price': product['price'],
                'description': product['description'],
                'category': product.get('category', ''),
                'images': product.get('images', []),
                'quantity': product.get('quantity', 0),
                'ratings': product.get('ratings', [])
            })

        return jsonify({
            'message': f"Tìm thấy {len(result)} sản phẩm phù hợp với '{keyword}'",
            'type': 'products',
            'products': result
        })

    except Exception as e:
        return jsonify({'error': f'Đã xảy ra lỗi: {str(e)}'}), 500
