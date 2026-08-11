---
title: "Bắn cảnh báo chi phí về Slack qua Amazon SNS"
weight: 2
chapter: false
pre: "10.2 "
description: "Cách thiết lập luồng gửi cảnh báo tự động từ AWS về kênh Slack của team để mọi người cùng thảo luận và xử lý."
services:
  - Amazon SNS
  - AWS Cost Anomaly Detection
  - Amazon Q Developer in chat applications
---
{{< badge "Amazon SNS" >}}
{{< badge "Định tuyến cảnh báo" >}}
{{< badge "Slack" >}}

## Kiến trúc Gửi cảnh báo

```text
AWS Cost Anomaly Detection
        ↓
Amazon SNS topic
        ↓
Amazon Q Developer in chat applications
        ↓
Kênh Slack riêng tư đã phê duyệt
        ↓
Chủ sở hữu phản hồi FinOps được chỉ định
```

Sử dụng SNS ở giữa làm "bưu điện". Nhờ đó, nếu sau này bạn muốn đổi sang gửi cảnh báo qua Microsoft Teams hay Email, bạn chỉ cần cấu hình lại SNS mà không cần động vào Cost Anomaly Detection.

## Quy tắc tạo Topic và Kênh Slack

SNS Topic sẽ được đặt tên là `finops-project-cost-anomalies`. Mọi cấu hình kết nối từ SNS sang Chatbot (Slack) đều phải được note lại rõ ràng.

Kênh Slack nhận cảnh báo BẮT BUỘC PHẢI LÀ KÊNH KÍN (Private Channel). Lý do: Cảnh báo chứa thông tin nhạy cảm về tài chính và ID hệ thống, không được để lộ ra ngoài.

## Test luồng cảnh báo (Testing)

TUYỆT ĐỐI KHÔNG dùng tool sinh tải (tạo chi phí giả) để ép AWS gửi cảnh báo. Thay vào đó, hãy dùng tính năng "Send test message" của SNS để verify luồng chạy:

```text
SNS topic:
Subscription bất thường:
Kênh/team đích:
Dấu thời gian kiểm thử:
Kết quả phân phối: PASS / FAIL
Đã thông báo cho chủ sở hữu:
```

Chỉ cần một dòng tin nhắn test bắn về Slack thành công là đủ để nghiệm thu bước này.

## Troubleshooting (Bắt bệnh luồng cảnh báo)

```text
1. Cost Anomaly báo lỗi, nhưng SNS không nhận được gì
→ Check lại quyền (Resource Policy) của SNS xem đã cho phép Cost Anomaly bắn thông báo vào chưa.

2. SNS nhận được tin, nhưng Slack im lìm
→ Check lại cấu hình AWS Chatbot (hoặc Q Developer) xem đã map đúng SNS Topic với Slack Channel chưa.

3. Slack nhảy tin nhắn ầm ầm, nhưng không ai xử lý
→ Lỗi quy trình (vận hành), không phải lỗi hệ thống. Team cần họp lại để phân công người trực cảnh báo rõ ràng.
```

{{< capture src="images/10-custom-anomaly/10-02-sns-slack-delivery.png" alt="Thông báo kiểm thử SNS có dấu thời gian được gửi tới kênh Slack đã phê duyệt" title="Kiểm thử phân phối từ SNS tới Slack" capture="Chụp một thông báo kiểm thử được hỗ trợ trong kênh đã phê duyệt, có dấu thời gian và kết quả phân phối hiển thị. Giữ lại đủ ngữ cảnh về topic hoặc subscription để nhận diện đường dẫn, nhưng che account ID, ARN, email, giá trị tài chính và chi tiết kênh riêng tư." caption="Bài kiểm thử có dấu thời gian chứng minh việc truyền tải mà không tạo chi tiêu AWS nhân tạo." >}}

## Trạng thái hiện tại của dự án

Kiến trúc và rule phân quyền đã chốt. Đang chờ team vận hành thực hiện bước cấu hình AWS Chatbot và chạy tin nhắn test.

{{< security >}}
Nội dung cảnh báo chỉ được chia sẻ với người nhận đã phê duyệt; bằng chứng kiểm thử không chứa thông tin xác thực hay mã định danh nhạy cảm của tổ chức.
{{< /security >}}
