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

Nếu trong Policy có lọt vào các quyền như `ec2:TerminateInstances`, `rds:DeleteDBInstance` hay `iam:CreateUser` thì ĐÁNH RỚT (FAIL) NGAY LẬP TỨC.

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

## Lưu ý về Customer-managed KMS

Dùng Customer-managed KMS (CMK) thì xịn đấy (kiểm soát được policy, audit log), nhưng nó kéo theo ti tỉ thứ phiền phức: tự lo key policy, rủi ro bị khóa (lock-out), và tốn thêm tiền hàng tháng. Chỉ dùng CMK nếu quy định bảo mật của công ty BẮT BUỘC, còn không thì cứ AWS-managed KMS (SSE-S3 hoặc SSE-KMS) mà táng.

Mã hóa lắm vào mà mất Key thì cũng khóc ròng. Đừng cấu hình lằng nhằng nếu không có quy trình backup/rotate Key đàng hoàng.

## Che dấu thông tin nhạy cảm (Redaction)

Trước khi chụp màn hình đi báo cáo, BẮT BUỘC phải che mờ (blur/redact) các thông tin sau: Access Key, Email, AWS Account ID, Tên S3 Bucket, ARN và Số tiền thực tế. Việc che mờ này giúp bảo vệ bí mật công ty mà vẫn chứng minh được là hệ thống đang chạy.

{{< capture src="images/11-security-governance/11-01-iam-kms-boundary.png" alt="Bằng chứng đã làm sạch về ranh giới IAM và mã hóa của stack phân tích FinOps" title="Ranh giới IAM và mã hóa" capture="Tạo một composite bằng chứng đã làm sạch, thể hiện role phân tích chỉ được cấp quyền S3/Glue/Athena/QuickSight cần thiết, mã hóa mặc định của S3 và mã hóa kết quả truy vấn Athena. Xác nhận các quyền làm thay đổi workload không tồn tại; che principal, ARN, tên bucket, account ID và key ID." caption="Bằng chứng bảo mật thể hiện ranh giới theo hướng đọc mà không công bố mã định danh nhạy cảm." >}}

{{< security >}}
Đặc quyền tối thiểu (Least Privilege) không phải là "cho ít quyền nhất", mà là "chỉ cho đúng quyền cần thiết để làm đúng việc, không thừa không thiếu".
{{< /security >}}
