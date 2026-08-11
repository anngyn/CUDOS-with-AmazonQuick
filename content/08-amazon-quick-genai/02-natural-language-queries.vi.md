---
title: "Đánh giá chất lượng trả lời của AI"
weight: 2
chapter: false
pre: "8.2 "
description: "Hướng dẫn cách kiểm tra xem AI (Amazon Q) có trả lời đúng trọng tâm, đúng số liệu và dẫn nguồn đầy đủ hay không."
services:
  - Amazon Quick
  - Chat Agents
  - CUDOS v5
---
{{< badge "Amazon Q" >}}
{{< badge "Đánh giá" >}}
{{< badge "FinOps" >}}

## Mục tiêu của bài test

Mục tiêu không phải là xem AI nói chuyện có mượt hay không. Mục tiêu là để check xem AI có lấy đúng con số trên Dashboard (và Athena) ra để trả lời không, có ghi nguồn đầy đủ không, và có biết phân biệt giữa sự thật và giả thuyết hay không.

## Các nhóm câu hỏi Test

| Nhóm | Câu hỏi ví dụ | Cách xử lý bằng chứng bắt buộc |
|---|---|---|
| Tổng quan (Visibility) | Năm dịch vụ nào tốn nhiều tiền nhất? | Phải nêu rõ tháng nào và loại chi phí gì |
| Biến động (Change) | Dịch vụ nào có chi phí tăng mạnh nhất? | Phải nói rõ tăng bao nhiêu USD (tuyệt đối) và tăng bao nhiêu % |
| Phân bổ (Allocation) | Account hoặc Region nào là nguyên nhân chính gây ra mức tăng này? | Chỉ được phép phân tích dựa trên các filter có sẵn trên Dashboard |
| Điều tra (Investigation) | Tôi nên đi kiểm tra nguyên nhân từ đâu trước? | Phải tách bạch rõ: Đâu là dữ liệu thấy được, đâu là suy đoán, đâu là bước cần đi check |

## Biên bản Test

| Prompt | Giá trị có thẩm quyền | Giá trị Amazon Quick trả lời | Đã nêu phạm vi/chỉ số | Kết quả |
|---|---:|---:|---|---|
| Dịch vụ đứng đầu | AmazonEC2 — $693.30 net unblended cost | AmazonEC2 — $693.30 net unblended cost | July 2026; `ap-southeast-2`; net unblended cost | PASS |
| Thay đổi lớn nhất | Chưa đánh giá | Chưa đánh giá | — | CHƯA ĐÁNH GIÁ |
| Phân bổ theo tài khoản/Region | Chưa đánh giá | Chưa đánh giá | — | CHƯA ĐÁNH GIÁ |

Dòng PASS được đối soát với dashboard dùng chung có nguồn Athena **tổng hợp (synthetic)**, không phải dữ liệu hóa đơn CUR thật. Đánh giá FAIL nếu AI đọc sai số, bỏ quên kỳ hoặc metric, tự kết luận nguyên nhân, hay đề xuất thay đổi hạ tầng không có bằng chứng. Văn phong trôi chảy không bù được cho sai lệch số liệu.

## Hướng xử lý khi AI trả lời sai

```text
1. Đọc sai số
→ Kiểm tra lại xem AI có đang đọc đúng Dashboard không, có bị kẹt filter cũ không, hay do bản thân SPICE chưa refresh.

2. Đọc đúng số, nhưng giải thích nguyên nhân không được chứng minh
→ Siết guardrails: yêu cầu tách quan sát khỏi giả thuyết và dẫn nguồn khi giải thích.

3. Đề xuất thay đổi hệ thống không đúng thẩm quyền
→ Chặn luồng tự động hóa (nếu có) và yêu cầu người phụ trách phê duyệt trước khi thực thi.
```

Chỉ cần lưu 1–2 câu hỏi/trả lời tiêu biểu làm bằng chứng nghiệm thu. Bảng đánh giá số liệu mới là nguồn quyết định PASS hoặc FAIL; không cần lưu toàn bộ lịch sử chat.

{{< capture src="images/08-amazon-quick/08-01-grounded-finops-answer.png" alt="Câu trả lời Amazon Quick có grounding đúng trên dashboard CUDOS tổng hợp đã chọn" title="Câu trả lời Amazon Quick có grounding" capture="Ảnh hiển thị dashboard được chọn, câu hỏi, câu trả lời, kỳ July 2026, phạm vi ap-southeast-2, giá trị AmazonEC2 và sheet nguồn. Đây là bài test thành công trên nguồn Athena tổng hợp dùng chung." caption="Câu trả lời đã PASS: AmazonEC2 có $693.30 net unblended cost trong July 2026 tại ap-southeast-2. Bằng chứng là dữ liệu tổng hợp, không phải số hóa đơn CUR thật." >}}

{{< finops title="Điểm rút ra về FinOps" >}}
AI giúp người dùng tiếp cận dữ liệu nhanh hơn; nguồn dữ liệu tài chính có kiểm soát mới quyết định độ tin cậy của hệ thống.
{{< /finops >}}
