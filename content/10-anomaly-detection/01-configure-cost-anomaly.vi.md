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

## Tại sao phải lọc kép (% và $)?

Nếu chỉ lọc theo %: Chi phí tăng từ `$0.01` lên `$0.10` (tăng 900%), hệ thống cũng sẽ hú còi. Rất phiền phức!
Nếu chỉ lọc theo $: Bạn có thể bỏ sót các workload nhỏ nhưng đang bị rò rỉ chi phí (tăng dần đều).
=> Việc kết hợp cả hai điều kiện sẽ giúp chỉ những sự cố thực sự ĐÁNG TIỀN mới lọt vào hàng đợi xử lý của team.

## Lưu ý về Thời gian Train Data

Dịch vụ ML này cần thời gian để "học" (train) dữ liệu lịch sử. Nếu vừa bật xong mà chưa thấy cảnh báo gì thì đừng lo, không phải do bạn cài sai đâu, chỉ là nó đang học thôi.

Những nguyên nhân mà AWS gợi ý (VD: do EC2 tăng) chỉ là MANH MỐI. Việc của bạn là đi tìm nguyên nhân thực sự (VD: do ai bật EC2 mà quên tắt).

{{< capture src="images/10-custom-anomaly/10-01-cost-anomaly-monitor.png" alt="Bằng chứng cấu hình monitor và subscription của AWS Cost Anomaly Detection" title="Monitor bất thường đang hoạt động và thông tin sở hữu" capture="Chụp phần tóm tắt monitor và subscription, thể hiện tên monitor, phạm vi dịch vụ, tần suất cảnh báo, ngưỡng trọng yếu, đích nhận và chủ sở hữu phản hồi. Có thể không có bất thường được phát hiện vì monitor mới vẫn đang học." caption="Tài liệu này chứng minh monitor được quản trị đã tồn tại; không thể dùng việc chưa xuất hiện bất thường để khẳng định rủi ro bằng không." >}}

## Trạng thái hiện tại của dự án

Cấu hình Monitor, quy tắc đặt tên và ngưỡng cảnh báo đã được chốt. Tuy nhiên, tính năng này hiện vẫn đang trong giai đoạn theo dõi, chưa có dữ liệu cảnh báo thực tế nào được sinh ra.

## Tài liệu tham khảo chính thức

https://docs.aws.amazon.com/cost-management/latest/userguide/manage-ad.html
