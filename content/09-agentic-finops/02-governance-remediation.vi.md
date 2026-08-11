---
title: "Phân quyền AI, Quy trình Duyệt và Sửa lỗi"
weight: 2
chapter: false
pre: "9.2 "
description: "Phân định rõ AI được phép tự động làm gì, và khi nào thì BẮT BUỘC phải có con người nhúng tay vào để sửa lỗi hệ thống."
services:
  - Amazon Q
  - AWS IAM
  - FinOps Governance
---
{{< badge "Quản trị" >}}
{{< badge "Con người xem xét" >}}
{{< badge "FinOps" >}}

## Các Cấp độ Tự động hóa

| Cấp độ | Khả năng của AI | Trạng thái dự án |
|---|---|---|
| Mức 0 | Phân tích thủ công bằng tay | Đang làm |
| Mức 1 | Tự động phát hiện bất thường | Đã có (dùng AWS Cost Anomaly Detection) |
| Mức 2 | Tự động điều tra nguyên nhân | Có thể dùng Q Flows (Tùy chọn) |
| Mức 3 | Tự động đề xuất cách sửa lỗi | Có tính năng này, nhưng con người phải duyệt |
| Mức 4 | Tự động sửa lỗi (Remediation) | KHÔNG ÁP DỤNG cho AI phân tích |

Dự án FinOps này chỉ dừng lại ở Mức 1 đến Mức 3. Việc can thiệp trực tiếp vào hạ tầng (Mức 4) phải do các team kỹ thuật (Workload Owner) đảm nhiệm, vì chỉ họ mới hiểu rõ lịch bảo trì (maintenance window), rủi ro kinh doanh và cách rollback.

## Những việc AI TUYỆT ĐỐI BỊ CẤM

Tài khoản (IAM Role) cấp cho AI phân tích KHÔNG ĐƯỢC PHÉP:

- Tắt, xóa, hay reboot EC2 Instance;
- Tạm dừng hay xóa database RDS;
- Xóa file trên S3;
- Thay đổi quyền IAM;
- Tự ý quẹt thẻ mua Savings Plans (SP) hay Reserved Instances (RI).

Đây không phải là trò đùa kiểu "dặn AI trong prompt". Bạn PHẢI dùng IAM Policy để khóa cứng các quyền này lại ở mức hạ tầng.

## Biên bản Đề xuất Sửa lỗi (Approval Package)

```text
Bằng chứng quan sát được:
Tác động tài chính:
Phạm vi bị ảnh hưởng:
Hành động đề xuất:
Cần kiểm chứng:
Chủ sở hữu:
Rủi ro và rollback:
Trạng thái phê duyệt:
```

Luôn phải chốt lại bằng dòng chữ:

```text
Trạng thái: REVIEW REQUIRED
Chưa thực thi thay đổi workload nào.
```

## Tách bạch hai môi trường (Security Domains)

```text
Môi trường Phân tích (Analytics Domain)
→ Dùng để cảnh báo, query dữ liệu, tìm nguyên nhân và gợi ý cách sửa.

Môi trường Vận hành (Workload Domain)
→ Dùng để thực thi code, deploy, rollback và chạy production.
```

Việc tách biệt này nhằm đảm bảo: Nếu có ai đó hack được cái Dashboard CUDOS hay con AI, thì chúng cũng không thể nào phá sập được hệ thống Production của bạn.

{{< security >}}
Nhắc lại lần nữa: Lời dặn dò trong Prompt chỉ là phần mềm; IAM Policy mới là phần cứng bảo vệ hệ thống của bạn.
{{< /security >}}
