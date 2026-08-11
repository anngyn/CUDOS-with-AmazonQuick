---
title: "Quy trình Dọn dẹp (Tear-down)"
weight: 1
chapter: false
pre: "12.1 "
description: "Quản lý vòng đời tài nguyên theo đúng thứ tự để tránh chi phí không cần thiết và bảo toàn bằng chứng dự án."
duration: "15 phút"
services:
  - Amazon Quick
  - CUDOS v5
  - AWS Data Exports
  - AWS CloudFormation
  - Amazon S3
---
{{< badge "Dọn dẹp" >}}
{{< badge "AWS CloudFormation" >}}
{{< badge "Amazon Quick" >}}


Đây là Hướng dẫn Vận hành (Runbook). Trong khâu Dọn dẹp, THỨ TỰ là quan trọng nhất: xóa nhầm nguồn dữ liệu trước khi xóa ứng dụng có thể làm treo hệ thống. Còn nếu quên không xóa thì bạn sẽ bị trừ tiền hàng tháng.

```text
Lập danh mục và quyết định sở hữu
→ tài sản AI nâng cao
→ tài sản BI tùy chỉnh
→ tài sản CUDOS
→ định tuyến bất thường
→ stack Data Export và thu thập
→ xác minh billing cập nhật trễ
```


## Kiểm kê Tài nguyên

Ghi nhận:

- Quick Space
- chat agent
- Quick Flow
- custom Quick Sight analysis/dashboard
- tài sản CUDOS
- monitor/subscription của Cost Anomaly Detection
- SNS topic
- cấu hình Slack/chat
- Data Export
- CloudFormation stack
- S3 bucket/prefix
- tài nguyên Glue/Athena

Mỗi mục nhận trạng thái `RETAIN` (Giữ lại) hoặc `DELETE` (Xóa bỏ), một chủ sở hữu và lý do. Không chạy lệnh xóa theo tên suy đoán, ví dụ xóa mọi bucket có chữ `test`.


## Xóa các thành phần Amazon Q

Chỉ xóa các tài sản do dự án tạo:

1. Quick Flow
2. custom chat agent
3. FinOps Space


## Xóa QuickSight Dashboard tùy chỉnh

Xóa `FinOps Project Dashboard` và analysis của dự án nếu không còn cần.

## Xóa CUDOS

Hãy dùng tool cài đặt gốc (`cid-cmd`) để xóa.

Vì là lệnh nguy hiểm, hãy check kỹ hướng dẫn bằng:

```bash
cid-cmd --help
```

Đừng đoán lệnh, sai một li đi một dặm.


## Xóa phần Cảnh báo (Anomaly Detection)

Nếu chỉ được tạo cho dự án này:

- xóa anomaly subscription
- xóa custom monitor
- xóa SNS topic
- xóa Slack/chat mapping


## Xóa CUR Data Export và CloudFormation

LƯU Ý CỰC KỲ QUAN TRỌNG: Bạn PHẢI xóa hết file trong S3 Bucket (Empty Bucket) trước khi xóa CloudFormation Stack, nếu không Stack sẽ bị kẹt ở trạng thái `DELETE_FAILED`.

1. Xác nhận không có export dùng chung nào phụ thuộc vào stack.
2. Xóa Data Export của dự án nếu không còn cần.
3. Chỉ làm trống dữ liệu S3 do dự án sở hữu nếu cần thiết.
4. Xóa `CID-DataExports-Destination`.
5. Theo dõi quá trình xóa.



{{< cost >}}
Nguyên tắc vàng: Mình đẻ ra cái gì thì mình tự dọn cái đó. Quên dọn thì tốn tiền, nhưng DỌN NHẦM đồ của team khác (nhất là đồ Shared) thì còn mang họa lớn hơn.
{{< /cost >}}
