---
title: "Cấu trúc Account và Môi trường triển khai"
weight: 2
chapter: false
pre: "3.2 "
description: "Ghi nhận cấu trúc sử dụng một Account duy nhất, lựa chọn Region và quyền truy cập Control Plane cần thiết để triển khai nền tảng dữ liệu."
services:
  - AWS STS
  - AWS Billing
  - AWS CloudFormation
---
{{< badge "AWS STS" >}}
{{< badge "AWS Billing" >}}
{{< badge "AWS CloudFormation" >}}

## Quyết định cấu trúc (Topology)

Ở giai đoạn đầu triển khai, chúng ta sẽ sử dụng một AWS Account duy nhất đóng cả hai vai trò: vừa là Nguồn xuất dữ liệu Billing, vừa là Đích lưu trữ dữ liệu (Data Collection). Cách làm này giúp giảm thiểu rắc rối về cấp quyền liên tài khoản (cross-account) và không phải quản lý nhiều Stack phức tạp, giúp dự án nhanh chóng chứng minh được khả năng đẩy dữ liệu (delivery), thiết lập schema và độ tương thích với hệ thống CUDOS.

```text
Account nguồn billing
        =
Account data collection
```

Sau này, thiết kế có thể nâng cấp lên mô hình Management/Payer Account riêng biệt và Data Account riêng biệt. Nhưng tuyệt đối không nên nhồi nhét cấu trúc phức tạp đó vào lần xác thực (PoC) đầu tiên, vì nó sẽ kéo theo hàng tá rủi ro về phân quyền IAM và chính sách bảo mật của tổ chức.

## Kiểm tra môi trường triển khai

ID của AWS Account (Account identifier) phải được lấy trực tiếp từ lệnh STS để đảm bảo độ chính xác, thay vì copy/paste từ tài liệu hay screenshot cũ:

```powershell
aws sts get-caller-identity `
  --profile <PROFILE> `
  --query Account `
  --output text
```

Bối cảnh dự án được ghi nhận như sau:

```text
Account nguồn: <ACCOUNT_ID>
Account đích: <ACCOUNT_ID>
Region triển khai: ap-southeast-2
Quyền truy cập Billing/Data Exports: đã xác nhận
Quyền truy cập CloudFormation: đã xác nhận
```

{{< evidence src="images/03-cur2/03-01-data-exports-home.png" alt="Bảng điều khiển Data Exports trong AWS Billing and Cost Management" caption="Mặt phẳng điều khiển Data Exports trước khi tạo bản xuất dữ liệu của dự án." >}}

## Lưu ý về mặt kiến trúc

Khi bạn nhập chính Account ID hiện tại vào tham số `SourceAccountIds`, AWS sẽ ngầm hiểu đây là kiến trúc một tài khoản (Single-account). Do đó, bạn không bắt buộc phải tạo thêm một Stack phụ ở nguồn (source stack). Nếu sau này bạn muốn tách riêng Source Account và Destination Account, bạn sẽ phải xem xét và điều chỉnh lại thiết lập này để phù hợp với mô hình Multi-account.

{{< validation >}}
Môi trường triển khai chỉ hợp lệ khi Source Account, Destination Account, Region và quyền truy cập Control Plane được khai báo rõ ràng, nhất quán tuyệt đối với kiến trúc Single-account mà dự án đã chốt.
{{< /validation >}}
