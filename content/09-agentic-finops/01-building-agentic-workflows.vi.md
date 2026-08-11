---
title: "Tự động hóa Quy trình Điều tra Chi phí"
weight: 1
chapter: false
pre: "9.1 "
description: "Sử dụng Q Flows để tự động hóa quy trình phân tích chi phí, thu thập bằng chứng mà không can thiệp vào hệ thống thực."
services:
  - Amazon Quick
  - Quick Flows
  - CUDOS v5
---
{{< badge "Amazon Q" >}}
{{< badge "Q Flows" >}}
{{< badge "Điều tra có quản trị" >}}

## Mục đích của Q Flows

Khi có biến động chi phí, bạn thường phải làm đi làm lại một chuỗi các bước điều tra. Q Flows giúp bạn tự động hóa chuỗi này (ví dụ: Flow `Cost Anomaly Investigation`), nhưng AI chỉ dừng ở mức phân tích chứ không được tự ý sửa lỗi hệ thống.

```text
Nhận cảnh báo (Alert) + Ngưỡng (Threshold)
→ AI tự động đọc dữ liệu CUDOS
→ Tìm ra các dịch vụ/account tăng đột biến
→ Phân tích nguyên nhân và đưa ra giả thuyết
→ Đề xuất các bước verify
→ Gói gọn thành một Report cho con người duyệt
```

## Thông số Đầu vào (Input) và Tính trọng yếu (Materiality)

Flow cần bạn cung cấp các thông số rõ ràng chứ không tự đoán bừa:

```text
Alert Threshold: tăng 20%
Analysis Time Period: 30 ngày gần nhất so với 30 ngày trước
```

Mẹo thực chiến (Production): Hãy kết hợp cả phần trăm (%) và số tiền tuyệt đối ($) làm ngưỡng. Tránh trường hợp chi phí tăng 1000% (nhưng từ $0.1 lên $1) mà hệ thống cũng gửi cảnh báo rác.

## Bước Trích xuất Bằng chứng

Trong giai đoạn này, AI sẽ đọc dữ liệu từ CUDOS và thực hiện:

```text
Phân tích xu hướng chi phí trong khoảng thời gian @Analysis Time Period.
Tìm ra các khoản mục tăng vượt mức @Alert Threshold.
Liệt kê các khoản tăng mạnh nhất theo Service, Account, Region, loại sử dụng hoặc chính xác từng Resource.
Chỉ đọc số, CHƯA đoán nguyên nhân gốc (Root cause).
```

Việc rạch ròi "chưa đoán nguyên nhân" giúp AI không bị nhầm lẫn giữa Hiện tượng thực tế (chi phí tăng) và Giả thuyết (bị tấn công, hay deploy lỗi).

## Bước Suy luận và Lập báo cáo

Ở bước này, AI sẽ đưa ra các kịch bản có thể xảy ra và cách để verify chúng. Một Report hoàn chỉnh sẽ bao gồm:

```text
Bằng chứng quan sát được
Tác động tài chính
Phạm vi bị ảnh hưởng
Nguyên nhân có thể có
Cần kiểm chứng
Chủ sở hữu
Hành động đề xuất
Rủi ro và rollback
Trạng thái: REVIEW REQUIRED
```

Không gắn công cụ thay đổi workload nào vào Flow.

## Đánh giá Kết quả của Flow

```text
Phiên bản/thời gian chạy Flow:
Kỳ và ngưỡng đầu vào:
Biến động lớn nhất do Flow báo cáo:
Giá trị chuẩn CUDOS/Athena:
Các yếu tố tác động quan sát được:
Các giả thuyết được tách rõ: yes/no
Có trạng thái con người xem xét: yes/no
Đã thực thi sửa lỗi: KHÔNG (Quan trọng)
Kết quả: PASS / FAIL
```

Chỉ cần lưu lại Report cuối cùng của Flow là đủ làm bằng chứng nghiệm thu, không cần thiết phải chụp lại giao diện kéo thả các node cấu hình.

{{< capture src="images/09-agentic-finops/09-01-cost-investigation-flow-result.png" alt="Kết quả Flow Cost Anomaly Investigation đã đánh giá và yêu cầu con người xem xét" title="Kết quả Flow điều tra có quản trị" capture="Chụp lần chạy Flow đã đánh giá ở trạng thái cuối, với kỳ đầu vào và các ngưỡng, biến động lớn nhất đã đối soát, bằng chứng quan sát được, các giả thuyết được tách riêng, nội dung cần kiểm chứng, chủ sở hữu, rủi ro và hoàn tác cùng trạng thái REVIEW REQUIRED. Thể hiện rằng không có hành động thay đổi workload nào được thực thi." caption="Lần chạy cuối cùng và bản đánh giá là bằng chứng; không cần các màn hình cấu hình node." >}}

## Trạng thái hiện tại của dự án

Luồng chạy và tiêu chí đánh giá đã có. Tuy nhiên, tính năng AI Flow này hiện vẫn đang trong giai đoạn thử nghiệm (tùy chọn), chưa bắt buộc phải áp dụng thực tế.

## Tài liệu tham khảo chính thức

https://docs.aws.amazon.com/guidance/latest/cloud-intelligence-dashboards/generative-ai.html
