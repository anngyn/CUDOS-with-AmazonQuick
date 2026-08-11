---
title: "Thiết lập Identity, Region và Ranh giới phân quyền"
weight: 1
chapter: false
pre: "2.1 "
description: "Xác định identity, Region và ranh giới đặc quyền tối thiểu dùng để triển khai và xác thực hệ thống FinOps."
services:
  - AWS CLI
  - AWS STS
  - AWS IAM
---
{{< badge "AWS CLI" >}}
{{< badge "AWS STS" >}}
{{< badge "AWS IAM" >}}

## Vai trò của Identity khi triển khai

Tài khoản (Identity) dùng để triển khai là một phần cốt lõi của kiến trúc, chứ không đơn thuần là một bước setup cho có. Nó sẽ chịu trách nhiệm tạo hoặc kiểm tra dữ liệu billing export, S3, Glue, Athena, các resource IAM, và cả các asset trên QuickSight. Nếu thông tin Identity này mập mờ, về sau bạn sẽ không thể audit được ai hoặc Region nào đang thực sự sở hữu dữ liệu.

Quá trình triển khai sẽ sử dụng một AWS CLI profile cụ thể và cố định Region phân tích ở `ap-southeast-2`. Điều này giúp đảm bảo môi trường luôn được tái lập chính xác, trong khi các thông tin nhạy cảm (credentials) không bị lọt vào source code.

## Kiểm tra Identity

Bạn có thể chạy các lệnh kiểm tra (probe) sau để xác minh chính xác AWS Account và Principal đang được sử dụng:

```powershell
aws --version

aws sts get-caller-identity `
  --profile <PROFILE>
```

Thông tin cần lưu lại để đối soát chỉ bao gồm:

```text
Bí danh AWS CLI profile:
AWS account ID:
Principal ARN/type:
Thời điểm kiểm chứng:
```

Lưu ý: Tuyệt đối không bao giờ lưu Access key, Session token, hay credential file vào repository của dự án.

## Lựa chọn Region (Khu vực)

Tất cả các thành phần từ thu thập dữ liệu đến BI đều được ưu tiên gom về một Region duy nhất (VD: Sydney):

```powershell
$env:AWS_PROFILE="<PROFILE>"
$env:AWS_REGION="ap-southeast-2"
$env:AWS_DEFAULT_REGION="ap-southeast-2"

aws ec2 describe-regions `
  --region ap-southeast-2 `
  --query "Regions[?RegionName=='ap-southeast-2'].RegionName" `
  --output text
```

Việc gom chung về một Region sẽ giảm thiểu các rắc rối liên mạng giữa CloudFormation, Glue, Athena, QuickSight và SPICE. Mặc dù dữ liệu Billing mang tính toàn cầu (global), nhưng hầu hết các công cụ phân tích lại hoạt động theo Region.

## Ranh giới phân quyền (Permission Boundaries)

Identity dùng để triển khai cần được cấp quyền (permissions) đủ rộng để tạo các tài nguyên thu thập dữ liệu và dashboard chính thức. Ngược lại, người dùng cuối (Analytics user) chỉ nên được cấp quyền Read/Query/View Dashboard.

```text
Identity dùng để triển khai (Deployer)
→ Có quyền tạo/cập nhật hệ thống thu thập dữ liệu và các BI asset

Identity của người dùng (Analytics User)
→ Chỉ có quyền đọc S3 thông qua các đường dẫn truy vấn hợp lệ
→ Chỉ có quyền truy vấn Glue/Athena
→ Chỉ có quyền xem và sử dụng các Dashboard QuickSight đã được chia sẻ

Identity của AI / Agent
→ Chỉ có quyền đọc từ các nguồn dữ liệu FinOps đã được duyệt
→ Tuyệt đối KHÔNG có quyền thay đổi hay xóa tài nguyên (EC2, RDS, IAM, v.v.)
```

Khi gặp lỗi `AccessDenied` lúc chạy CloudFormation, hãy kiểm tra và bổ sung đúng quyền còn thiếu cho chính xác resource đó. Tuyệt đối không gắn quyền `AdministratorAccess` để bypass nhanh, vì nó sẽ phá vỡ mọi tiêu chuẩn bảo mật của hệ thống.

{{< validation >}}
Môi trường thực thi chỉ hợp lệ khi CLI trỏ đúng vào một Account/Principal cụ thể, chạy đúng Region `ap-southeast-2`, và có sự tách bạch rõ ràng giữa quyền của người đi deploy (Triển khai) và người xem báo cáo (Phân tích).
{{< /validation >}}

{{< security >}}
Account ID và ARN là các identifier chứ không phải password, nhưng artifact công khai vẫn được rà soát để tránh vô tình tiết lộ cấu trúc account nội bộ.
{{< /security >}}
