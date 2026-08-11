---
title: "AWS FinOps Intelligence với CUDOS v5"
chapter: false
description: "Dự án AWS FinOps có dữ liệu đối soát thực tế, được xây dựng trên CUR 2.0, Athena, CUDOS v5, QuickSight và cơ chế tự động hóa có quản trị."
---

# AWS FinOps Intelligence với CUDOS v5

Kho lưu trữ này trình bày bài toán kinh doanh, kiến trúc, quyết định triển khai, bằng chứng xác thực, mô hình vận hành và các phần còn đang hoàn thiện như một dự án AWS FinOps có thể truy vết.

## Cách đọc dự án

| Lớp | Chương | Câu hỏi được trả lời |
|---|---|---|
| Bằng chứng tài chính | 3–5 | Dữ liệu billing đã được bàn giao, truy vấn và hiển thị trên sản phẩm phân tích chưa? |
| Quyết định FinOps | 6–7 | Biến động nào đáng chú ý, ai sở hữu và kết quả được đo lường thế nào? |
| Vận hành có hỗ trợ | 8–10 | Bằng chứng đã phê duyệt có thể được giải thích, điều tra và định tuyến mà không tự động remediation hay không? |
| Quản trị và vòng đời | 11–12 | Quyền nào, tài nguyên nào được giữ lại và nhịp review nào giúp hệ thống vận hành an toàn? |

Khi triển khai, nên đọc theo thứ tự chương. Khi đánh giá một quyết định, bắt đầu từ nguồn và metric đã nêu tên, sau đó lần theo bằng chứng đến chủ sở hữu và hành động tiếp theo do con người phê duyệt.

{{< badge "FinOps" >}}
{{< badge "CUDOS v5" >}}
{{< badge "CUR 2.0" >}}

## Bài toán kinh doanh

Dữ liệu thanh toán AWS rất chi tiết nhưng phân tán. Bộ phận tài chính cần tổng chi phí đáng tin cậy; đội ngũ kỹ thuật cần biết tài nguyên nào tạo ra chi phí đáng kể; còn service owner cần bằng chứng đủ rõ để quyết định. Nếu không có luồng phân tích chuẩn hóa, các team phải phụ thuộc vào kiểm tra Cost Explorer thủ công hoặc tranh luận về các con số khác kỳ, khác metric, khác filter hoặc khác thời điểm refresh.

Dự án này giải quyết vấn đề trên bằng cách xây dựng một luồng dữ liệu minh bạch, có thể truy xuất từ lúc xuất hóa đơn cho đến khi đưa ra quyết định vận hành.

## Kiến trúc được triển khai

```text
AWS Billing
   ↓
AWS Data Exports / CUR 2.0       Bằng chứng tài chính
   ↓
Amazon S3 + AWS Glue             Lưu trữ và danh mục dữ liệu (catalog)
   ↓
Amazon Athena                    Truy vấn đối soát nhất quán
   ↓
CUDOS v5 + QuickSight            Sản phẩm phân tích FinOps
   ↓
Amazon Q / Flows                 Trợ lý điều tra thông minh (tùy chọn)
   ↓
Con người phê duyệt + nhịp vận hành  Hành động có quản trị
```

Cost Anomaly Detection và SNS cung cấp tín hiệu vận hành bao quanh luồng phân tích này.

## Mục tiêu của dự án

- Lớp thu thập CUR 2.0 có khả năng tiếp nhận dữ liệu định dạng Parquet thực tế;
- Các bảng Athena được lập danh mục (catalog) rõ ràng, đi kèm với các truy vấn SQL để dễ dàng đối soát;
- Mô hình triển khai CUDOS đi kèm với bước kiểm tra trạng thái sẵn sàng của SPICE;
- Quy trình đối soát có kiểm soát giữa Athena và CUDOS;
- Cấu trúc hóa các thông tin FinOps, bao gồm: người chịu trách nhiệm, bằng chứng cụ thể, hành động cần làm và kết quả đạt được;
- Định nghĩa rõ cách phân bổ chi phí và các chỉ số unit economics;
- Thiết lập cảnh báo chi phí bất thường, quản lý phân quyền và vòng đời tài nguyên;
- Tích hợp một lớp AI (tùy chọn) để giải thích dữ liệu đã được đối soát, không dùng AI để thay thế số liệu gốc.

## Trạng thái bàn giao hiện tại

| Năng lực | Trạng thái | Bằng chứng |
|---|---|---|
| Thu thập CUR 2.0 | Đã đối soát | Dữ liệu Parquet thực tế trong phân vùng thanh toán hiện tại |
| Athena và Glue | Đã đối soát | Database, bảng, schema, kết quả truy vấn và thống kê dữ liệu đã quét |
| CUDOS v5 và Amazon Quick | Đã triển khai | Đã giữ bằng chứng CUDOS v5, dataset, dashboard và walkthrough tổng hợp được gắn nhãn rõ ràng |
| Phân tích FinOps | Đã xác thực measurement tổng hợp | Đã đối soát ví dụ optimization, allocation và unit economics; kết quả tài khoản thật vẫn đang chờ |
| Amazon Q và Flows | Phần mở rộng tổng hợp đang chạy | Topic có grounding và Flow có quản trị đã chạy trên nguồn demo dùng chung; production grounding vẫn là tùy chọn |
| Cảnh báo và quản trị | Đã triển khai một phần | Có service monitor, nền tảng SNS routing, security audit và retained-resource inventory; còn chờ endpoint/test delivery |

Tiến độ được ghi chú rất rõ ràng: một bản thiết kế nằm trên giấy sẽ không được tính là một hệ thống đang chạy thực tế.

## Nội dung dự án

1. Bối cảnh và Kiến trúc
2. Thiết lập môi trường và Phân quyền
3. Xây dựng nền tảng dữ liệu CUR 2.0
4. Tích hợp Athena và Đối soát dữ liệu
5. Triển khai CUDOS v5
6. Phân tích số liệu FinOps và Unit Economics
7. Trực quan hóa dữ liệu với QuickSight
8. Tích hợp AI với Amazon Q
9. Xây dựng quy trình FinOps tự động
10. Hệ thống cảnh báo chi phí bất thường
11. Bảo mật và Quản trị hệ thống
12. Dọn dẹp tài nguyên

{{< cost >}}
Quá trình triển khai có thể phát sinh chi phí cho S3, Athena, SPICE, Amazon Q và các tài nguyên hỗ trợ. Mỗi tài nguyên được tạo ra đều phải có người chịu trách nhiệm và có quy định rõ ràng về thời điểm cần xóa bỏ.
{{< /cost >}}
