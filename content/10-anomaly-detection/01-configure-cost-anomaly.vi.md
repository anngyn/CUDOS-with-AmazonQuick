---
title: "Cấu hình AWS Cost Anomaly Detection (Phát hiện chi phí bất thường)"
weight: 1
chapter: false
pre: "10.1 "
description: "Sử dụng Machine Learning của AWS để phát hiện chi phí tăng đột biến, kết hợp với các bộ lọc (threshold) để tránh nhận cảnh báo rác."
services:
  - AWS Cost Anomaly Detection
  - AWS Cost Explorer
---
{{< badge "AWS Cost Anomaly Detection" >}}
{{< badge "Tính trọng yếu" >}}
{{< badge "FinOps" >}}

## Chiến lược Cảnh báo

AWS Cost Anomaly Detection là một dịch vụ tích hợp sẵn Machine Learning. Nó liên tục phân tích dữ liệu từ Cost Explorer (dựa trên chỉ số `net unblended cost`) để phát hiện ra các khoản chi phí bất thường theo từng Dịch vụ, Account, hoặc Region.

Tuy nhiên, để tránh bị spam cảnh báo, chúng ta sẽ áp dụng thêm một quy tắc lọc kép:

```text
mức tăng phần trăm (percentage increase) > ngưỡng
VÀ
mức tăng tuyệt đối (absolute increase) > ngưỡng
```

Tức là: ML của AWS sẽ tìm ra điểm bất thường, còn quy tắc của chúng ta sẽ quyết định xem bất thường đó có ĐÁNG để báo động hay không.

## Phạm vi Monitor

Ta sẽ tạo một Monitor theo từng Dịch vụ (Service Monitor) tên là `FinOpsProject-ServiceMonitor`. NHỚ CHECK KỸ xem trước đây đã có ai tạo Monitor trùng lặp chưa, nếu không bạn sẽ nhận 2 email cảnh báo cho cùng một lỗi.

```text
Tên monitor:
Phạm vi/loại:
Tài khoản/dịch vụ bao gồm:
Ngưỡng tác động chi phí do dịch vụ quản lý:
Ngưỡng phần trăm xác định:
Ngưỡng tuyệt đối xác định:
Tần suất cảnh báo:
Chủ sở hữu phản hồi:
Thời gian phản hồi dự kiến:
```

## Cấu hình đã triển khai

Monitor có quản trị sau đã được tạo tại `ap-southeast-2` (Sydney):

```text
Tên monitor: FinOpsProject-ServiceMonitor
Loại monitor: DIMENSIONAL / SERVICE
Ngưỡng tác động do AWS quản lý: USD 10
Tần suất cảnh báo: IMMEDIATE
Cost Anomaly subscription: finops-project-cost-anomaly-subscription
SNS topic: finops-project-cost-anomalies
Quy tắc FinOps để triage: mức tăng phần trăm > 20% VÀ mức tăng tuyệt đối > USD 10
```

AWS Cost Anomaly Detection áp dụng ngưỡng USD. Quy tắc 20% là quy tắc triage minh bạch do người phụ trách FinOps áp dụng khi xem xét; nó không phải filter bổ sung của Cost Anomaly Detection.

## Tại sao phải lọc kép (% và $)?

Nếu chỉ lọc theo %: Chi phí tăng từ `$0.01` lên `$0.10` (tăng 900%) vẫn có thể tạo cảnh báo dù tác động tài chính rất nhỏ.
Nếu chỉ lọc theo $: Bạn có thể bỏ sót các workload nhỏ nhưng đang bị rò rỉ chi phí (tăng dần đều).
=> Việc kết hợp cả hai điều kiện sẽ giúp chỉ những sự cố thực sự ĐÁNG TIỀN mới lọt vào hàng đợi xử lý của team.

## Lưu ý về Thời gian Train Data

Dịch vụ ML này cần thời gian để "học" (train) dữ liệu lịch sử. Nếu vừa bật xong mà chưa thấy cảnh báo gì thì đừng lo, không phải do bạn cài sai đâu, chỉ là nó đang học thôi.

Những nguyên nhân mà AWS gợi ý (VD: do EC2 tăng) chỉ là MANH MỐI. Việc của bạn là đi tìm nguyên nhân thực sự (VD: do ai bật EC2 mà quên tắt).

{{< capture src="images/10-custom-anomaly/10-01-cost-anomaly-monitor.svg" alt="Bằng chứng CLI trực tiếp đã làm sạch về cấu hình monitor và subscription AWS Cost Anomaly Detection" title="Monitor bất thường và nền tảng định tuyến" capture="Bằng chứng được tạo từ cấu hình AWS CLI trực tiếp, thể hiện tên monitor, phạm vi SERVICE, ngưỡng USD 10 immediate, SNS topic định tuyến và trạng thái detector đang học mà không lộ identifiers." caption="Tài liệu này chứng minh monitor và nền tảng routing có quản trị đã tồn tại. Nó không tuyên bố đã có bất thường, endpoint nhận tin hay rủi ro bằng không." >}}

## Trạng thái hiện tại của dự án

Đã tạo monitor và Cost Anomaly subscription dùng SNS tại Sydney. `LastEvaluatedDate` vẫn trống, điều này bình thường vì detector mới đang học mẫu chi phí của account. Chưa có bất thường nào được phát hiện hoặc tuyên bố là đã phát hiện.

SNS topic hiện chưa có email, Slack hay chat endpoint. Hạ tầng định tuyến đã tồn tại, nhưng mục 10.2 vẫn chờ endpoint được phê duyệt và một tin nhắn kiểm thử có dấu thời gian.

## Tài liệu tham khảo chính thức

https://docs.aws.amazon.com/cost-management/latest/userguide/manage-ad.html
