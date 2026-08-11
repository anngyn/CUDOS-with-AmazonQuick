---
title: "Tích hợp Amazon Q và Thiết lập nguồn tri thức (Grounding)"
weight: 1
chapter: false
pre: "8.1 "
description: "Tìm hiểu cách tích hợp tính năng AI (Amazon Q) vào QuickSight, cách cấp quyền truy cập dữ liệu (grounding) và thiết lập các hướng dẫn an toàn."
services:
  - Amazon Quick
  - Spaces
  - Chat Agents
---
{{< badge "Amazon Q" >}}
{{< badge "AI có grounding" >}}
{{< badge "Phần mở rộng tùy chọn" >}}

Tài liệu tham khảo chính thức:

`https://docs.aws.amazon.com/guidance/latest/cloud-intelligence-dashboards/generative-ai.html`

## Vai trò của Amazon Q

Amazon Q (trợ lý AI) giúp người dùng truy vấn dữ liệu FinOps bằng ngôn ngữ tự nhiên (chat). Lưu ý: Amazon Q chỉ là lớp giao diện mở rộng, nó KHÔNG tự tính toán ra dữ liệu tài chính gốc, và cũng không bắt buộc phải có trong kiến trúc lõi (CUR → Athena → CUDOS).

```text
Dashboard CUDOS / Quick Sight đã được phê duyệt
        ↓ liên kết vào
FinOps Space
        ↓ cung cấp grounding cho
FinOps Operations Advisor
        ↓ tạo ra
Giải thích và kế hoạch điều tra
        ↓ được kiểm chứng đối chiếu với
CUDOS và Athena
```

## Ranh giới Tri thức (Knowledge Boundary)

Để AI trả lời chính xác, ta tạo một không gian (Space) tên là `AWS FinOps Intelligence` chỉ chứa các Dashboard đã nghiệm thu. Con bot AI (được đặt tên là `FinOps Operations Advisor`) sẽ chỉ được phép đọc dữ liệu từ Space này.

Cách thiết lập "hàng rào" này giúp con AI không bị "ảo giác" (hallucinate) và không trả lời linh tinh dựa trên các dữ liệu rác hay dữ liệu chưa được kiểm duyệt của công ty.

## Các quy tắc Prompt (Guardrails)

```text
1. Chỉ được dùng số liệu từ các Dashboard FinOps trong Space đã chỉ định.
2. Luôn phải nhắc lại mốc thời gian (kỳ hóa đơn) khi báo cáo số tiền.
3. TUYỆT ĐỐI không được tự bịa ra các con số tài chính.
4. Phân biệt rõ giữa "Hiện tượng nhìn thấy trên biểu đồ" và "Nguyên nhân phỏng đoán".
5. Luôn đề xuất các bước kiểm tra lại (investigate) trước khi xui người dùng đi sửa lỗi.
6. Không được quyền xác nhận hay phê duyệt các thay đổi trên hệ thống thật.
```

Các quy tắc này giúp hạn chế rủi ro AI trả lời bậy, nhưng KHÔNG đảm bảo đúng 100%. Bạn vẫn phải dùng não để check lại số liệu.

## Ghi nhận Thông tin Agent

```text
Agent:
Space liên kết:
Dashboard liên kết:
Phiên bản hướng dẫn:
Chủ sở hữu:
Phạm vi chia sẻ:
Lần đánh giá gần nhất:
Trạng thái: READY / BLOCKED / OPTIONAL
```

## Trạng thái hiện tại của dự án

Kiến trúc dữ liệu, prompt guardrails và tiêu chí đánh giá đã được chốt. Tuy nhiên, tính năng AI này vẫn đang ở dạng tùy chọn (optional extension) chứ chưa phải tính năng bắt buộc của dự án.

{{< security >}}
Con AI chỉ cần quyền ĐỌC (Read-only) đối với các Dashboard. Tuyệt đối KHÔNG cấp cho nó quyền thay đổi hạ tầng (như quyền sửa EC2, RDS, S3 hay IAM).
{{< /security >}}
