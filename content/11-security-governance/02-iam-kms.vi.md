---
title: "Bảo mật Dữ liệu (IAM & KMS) cho FinOps"
weight: 2
chapter: false
pre: "11.2 "
description: "Thiết lập quyền truy cập Least Privilege (đặc quyền tối thiểu) và mã hóa dữ liệu nhạy cảm cho hệ thống phân tích."
services:
  - AWS IAM
  - AWS KMS
  - Amazon S3
  - Amazon Athena
---
{{< badge "AWS IAM" >}}
{{< badge "AWS KMS" >}}
{{< badge "Đặc quyền tối thiểu" >}}

## Ranh giới Phân quyền (Security Boundary)

Hệ thống phân tích FinOps của chúng ta CHỈ CÓ QUYỀN ĐỌC:

```text
Vai trò phân phối dữ liệu
→ ghi các object CUR và metadata đã được phê duyệt

Vai trò truy vấn/BI
→ đọc các prefix S3 và metadata Glue đã được phê duyệt
→ thực thi truy vấn Athena
→ làm mới và sử dụng tài sản Quick Sight

Vai trò AI/Flow
→ đọc các nguồn phân tích đã được phê duyệt
→ tạo giải thích/khuyến nghị
```

Nếu policy có các quyền như `ec2:TerminateInstances`, `rds:DeleteDBInstance` hay `iam:CreateUser`, ranh giới chỉ-đọc không còn đạt và cần được xử lý trước khi nghiệm thu.

## Review các IAM Roles

Các role và policy do template CID chính thức tạo ra được ánh xạ tới S3, Glue, Athena, Quick Sight và các custom resource hỗ trợ. Mỗi quyền được liên kết với một trách nhiệm runtime, thay vì được chấp nhận chỉ vì template do AWS duy trì.

```text
Role/policy:
Principal/service:
Actions/resources bắt buộc:
Lý do:
Quyền không mong đợi:
Kết quả rà soát:
```

## Mô hình Mã hóa (KMS)

Rà soát bao quát:

- mã hóa mặc định trên bucket Data Exports S3;
- mã hóa workgroup Athena và kết quả truy vấn;
- các quyền KMS cần thiết cho identity phân phối và identity truy vấn;
- quyền sở hữu key và việc xoay vòng khi sử dụng customer-managed key.

## Kết quả audit cấu hình đã triển khai

Audit CLI đã làm sạch tại `ap-southeast-2` xác nhận cả bucket Data Exports và Athena-results dùng mã hóa mặc định `AES256`, đồng thời bật đủ bốn lớp S3 Block Public Access. Athena workgroup `primary` ép cấu hình của nó và mã hóa kết quả query bằng `SSE_S3`.

Trust policy của `CidCmdQuickSightDataSourceRole` chỉ cho phép `quicksight.amazonaws.com`. Hai attached policy và một inline policy của role được rà soát đối với `ec2:TerminateInstances`, `rds:DeleteDBInstance` và `iam:CreateUser`; không có quyền nào khớp. Đây là kiểm tra có mục tiêu đối với các quyền làm thay đổi workload đã nêu, không phải chứng nhận toàn bộ mọi quyền IAM.

## Lưu ý về Customer-managed KMS

Dùng customer-managed KMS (CMK) tăng khả năng kiểm soát policy và audit, nhưng cũng yêu cầu sở hữu key policy, phương án tránh lock-out và chi phí vận hành. Chỉ chọn CMK khi có yêu cầu bảo mật hoặc tuân thủ rõ ràng; nếu không, AWS-managed encryption như SSE-S3 hoặc SSE-KMS thường phù hợp hơn.

Không tăng độ phức tạp mã hóa khi chưa có quy trình quản lý key, recovery và rotation tương ứng.

Workshop này dùng mã hóa S3 do AWS quản lý (`AES256` / `SSE_S3`), không dùng customer-managed KMS key. Chưa có yêu cầu nào biện minh cho gánh nặng key policy, khôi phục key và vận hành bổ sung của CMK.

## Che dấu thông tin nhạy cảm (Redaction)

Trước khi chụp màn hình đi báo cáo, BẮT BUỘC phải che mờ (blur/redact) các thông tin sau: Access Key, Email, AWS Account ID, Tên S3 Bucket, ARN và Số tiền thực tế. Việc che mờ này giúp bảo vệ bí mật công ty mà vẫn chứng minh được là hệ thống đang chạy.

{{< capture src="images/11-security-governance/11-01-iam-kms-boundary.svg" alt="Audit CLI trực tiếp đã làm sạch về ranh giới IAM và mã hóa của stack phân tích FinOps" title="Ranh giới IAM và mã hóa" capture="Composite bằng chứng được tạo từ audit CLI trực tiếp. Nó cho thấy mã hóa mặc định và public-access block của S3, mã hóa kết quả Athena, trust chỉ cho QuickSight và không khớp các quyền thay đổi workload đã rà soát. Tên bucket, principal, ARN, account ID và key ID đã được loại bỏ." caption="Audit cho thấy ranh giới triển khai theo hướng chỉ-đọc. Đây là rà soát quyền có mục tiêu, không phải tuyên bố đã chứng nhận toàn bộ mọi quyền IAM." >}}

{{< security >}}
Đặc quyền tối thiểu (Least Privilege) không phải là "cho ít quyền nhất", mà là "chỉ cho đúng quyền cần thiết để làm đúng việc, không thừa không thiếu".
{{< /security >}}
