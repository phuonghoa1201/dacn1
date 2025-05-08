import threading
from test2_cb import app 

def run_flask():
    app.run(host='0.0.0.0', port=5000, debug=False, use_reloader=False)

if __name__ == "__main__":
    try:
        flask_thread = threading.Thread(target=run_flask)
        flask_thread.start()

        print("✅ Server đã khởi động tại http://localhost:5000")
        print("⚠️ Nhấn Ctrl+C để dừng server")

        flask_thread.join()
    except Exception as e:
        print(f"❌ Lỗi: {str(e)}")
