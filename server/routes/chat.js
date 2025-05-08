
const express = require("express");
const axios = require("axios");
const { Product } = require("../models/product"); // Đảm bảo đúng đường dẫn tới model của bạn
const chatRouter = express.Router();


const GEMINI_API_KEY = "AIzaSyBaelXTrgDlNzn-usvo5ioEv4xIegBFLTY";
const GEMINI_API_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-pro:generateContent";


const introPrompt = `
Bạn là nhân viên chăm sóc khách hàng thân thiện tại TechZone. Dưới đây là một số sản phẩm đang có sẵn trong cửa hàng:


`;


// POST /chat
chatRouter.post("/chat", async (req, res) => {
 const userMessage = req.body.message;


 if (!userMessage) {
   return res.status(400).json({ error: "Tin nhắn không hợp lệ" });
 }


try {
    // 🔍 Lấy 10 sản phẩm mới nhất từ cơ sở dữ liệu
    const products = await Product.find().sort({ _id: -1 }).limit(10);


    if (products.length === 0) {
      return res.status(404).json({ error: "Không tìm thấy sản phẩm nào." });
    }


    const productDescriptions = products.map(p => {
      // Kiểm tra xem sản phẩm có ảnh không, nếu không thì gán giá trị mặc định
      const imageUrl = p.images.length > 0 ? p.images[0] : 'https://yourdomain.com/default-image.jpg';


      return `- ${p.name} [${p.category}]
        Giá: ${p.price.toLocaleString("vi-VN")} VNĐ
        ${p.description}
//         Link: https://yourdomain.com/products/${p._id}
        Hình ảnh: ${imageUrl}`;  // Bao gồm cả URL hình ảnh
    }).join("\n\n");


    // Tạo prompt hoàn chỉnh cho chatbot
    const fullPrompt = `${introPrompt}${productDescriptions}


Hãy hỗ trợ khách hàng dựa trên danh sách trên. Nếu họ chưa rõ, bạn có thể hỏi thêm để tư vấn phù hợp.`;


   // Gửi yêu cầu đến Gemini API để lấy phản hồi từ chatbot
   const response = await axios.post(
     `${GEMINI_API_URL}?key=${GEMINI_API_KEY}`,
     {
       contents: [
         {
           role: "user",
           parts: [
             { text: fullPrompt },
             { text: userMessage }
           ]
         }
       ]
     },
     {
       headers: {
         "Content-Type": "application/json"
       }
     }
   );


   // Lấy phản hồi từ Gemini API
   const botReply = response.data.candidates?.[0]?.content?.parts?.[0]?.text || "Xin lỗi, mình chưa thể trả lời.";
   res.json({ reply: botReply });


 } catch (err) {
   console.error("Lỗi khi gọi Gemini API:", err.response?.data || err.message);


   if (err.response?.status === 400) {
     return res.status(400).json({ error: "Yêu cầu không hợp lệ từ Gemini API" });
   } else if (err.response?.status === 500) {
     return res.status(500).json({ error: "Lỗi hệ thống từ Gemini API" });
   } else {
     return res.status(500).json({ error: "Lỗi hệ thống, vui lòng thử lại sau." });
   }
 }
});


module.exports = chatRouter;
