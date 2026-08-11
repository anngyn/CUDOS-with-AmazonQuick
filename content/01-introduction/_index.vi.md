---
title: "Bối cảnh và Kiến trúc"
weight: 1
chapter: false
pre: "1. "
description: "Bài toán kinh doanh, tiêu chí thành công, kiến trúc và ranh giới thiết kế."
duration: "10 phút"
services:
  - AWS Billing
  - FinOps
  - Amazon Quick
---
{{< badge "AWS Billing" >}}
{{< badge "FinOps" >}}
{{< badge "Amazon Quick" >}}


Chương này giải thích lý do hệ thống tồn tại, ý nghĩa của thành công, và vì sao bằng chứng, phân tích, trình bày và tự động hóa được tách thành các lớp riêng.

Dữ liệu AWS Billing chứa bằng chứng tài chính chi tiết, nhưng các bản ghi thô không tự động trả lời được những câu hỏi kinh doanh như:

- Dịch vụ nào đang tạo ra phần lớn chi tiêu?
- Tài khoản hoặc Region nào thay đổi nhiều nhất?
- Ai chịu trách nhiệm cho khoản chi phí?
- Thay đổi nào là dự kiến và thay đổi nào là bất thường?
- Đội FinOps nên điều tra từ đâu trước?

Dự án xây dựng một đường dẫn có thể truy vết, từ bằng chứng billing thô đến dashboard và hoạt động điều tra có hỗ trợ AI.

## Nội dung chương

- **1.1 Bối cảnh kinh doanh, mục tiêu & tiêu chí thành công**
- **1.2 Kiến trúc & quyết định thiết kế**

{{< finops title="Nguyên tắc FinOps" >}}
Sử dụng dữ liệu tài chính xác định làm nguồn chuẩn. Xây dashboard và AI trên bằng chứng đã có, thay vì yêu cầu AI tự tạo ra bằng chứng.
{{< /finops >}}
