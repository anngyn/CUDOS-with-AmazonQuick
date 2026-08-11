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

| Prompt | Giá trị CUDOS/Athena có thẩm quyền | Giá trị từ agent | Đã nêu phạm vi/chỉ số | Kết quả |
|---|---:|---:|---|---|
| Dịch vụ đứng đầu |  |  | yes/no | PASS/FAIL |
| Thay đổi lớn nhất |  |  | yes/no | PASS/FAIL |
| Phân bổ theo tài khoản/Region |  |  | yes/no | PASS/FAIL |

Đánh rớt (FAIL) ngay lập tức nếu AI: Đọc sai số, quên nhắc mốc thời gian, tự biên tự diễn nguyên nhân, hoặc xúi bậy người dùng đi xóa tài nguyên. Cho dù văn phong có trôi chảy mượt mà đến đâu mà số sai thì cũng vứt.

## Hướng xử lý khi AI trả lời sai

```text
1. Đọc sai số
→ Kiểm tra lại xem AI có đang đọc đúng Dashboard không, có bị kẹt filter cũ không, hay do bản thân SPICE chưa refresh.

2. Đọc đúng số, nhưng chém gió sai nguyên nhân
→ Sửa lại System Prompt (Guardrails) để cấm AI đoán bừa, bắt buộc nó phải trích dẫn nguồn khi giải thích.

3. Xúi bậy đi sửa hệ thống
→ Cắt ngay luồng tự động hóa (nếu có), yêu cầu phải có người thật (Human-in-the-loop) duyệt trước khi thực thi lệnh.
```

Bạn chỉ cần chụp lại 1-2 câu hỏi/trả lời tiêu biểu làm bằng chứng nghiệm thu là đủ. Không cần rảnh rỗi đi chụp lại toàn bộ lịch sử chat.

{{< capture src="images/08-amazon-quick/08-01-grounded-finops-answer.png" alt="Câu trả lời Amazon Q có grounding dựa trên bằng chứng CUDOS và Athena đã đối soát" title="Câu trả lời Amazon Q có grounding" capture="Chụp một câu hỏi và câu trả lời đại diện, thể hiện kỳ được yêu cầu, chỉ số chi phí có tên, giá trị theo phạm vi, phân bổ và bằng chứng có nguồn. Câu trả lời phải gắn nhãn các giả thuyết và không được ngụ ý rằng hoạt động khắc phục đã được phê duyệt." caption="Một câu trả lời đã đánh giá là đủ; bảng đánh giá số liệu quyết định PASS hoặc FAIL." >}}

{{< finops title="Điểm rút ra về FinOps" >}}
Chát chít với AI chỉ là phần ngọn cho vui vẻ dễ dùng, phần gốc rễ (nguồn dữ liệu tài chính chuẩn xác) mới là thứ quyết định thành bại của hệ thống.
{{< /finops >}}
