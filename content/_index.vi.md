---
title: "AWS FinOps Intelligence với CUDOS v5"
chapter: false
description: "Dự án AWS FinOps có dữ liệu đối soát thực tế, được xây dựng trên CUR 2.0, Athena, CUDOS v5, QuickSight và cơ chế tự động hóa có quản trị."
---

{{< finops-hero
  label="Dự án AWS FinOps · Sydney"
  headline="Biến dữ liệu billing thành quyết định FinOps có quản trị."
  summary="Một dự án CUDOS theo phong cách production, tách rõ nguồn tài chính, bằng chứng phân tích, khuyến nghị và phê duyệt của con người."
  proof_one_label="Nguồn tài chính"
  proof_one_value="CUR 2.0 → Athena"
  proof_two_label="Sản phẩm phân tích"
  proof_two_value="CUDOS v5 + Amazon Quick"
  proof_three_label="Rào chắn quyết định"
  proof_three_value="Có bằng chứng. Có người duyệt."
>}}

Kho lưu trữ này trình bày bài toán kinh doanh, kiến trúc, quyết định triển khai, bằng chứng xác thực, mô hình vận hành và các phần còn đang hoàn thiện như một dự án AWS FinOps có thể truy vết.

{{< badge "FinOps" >}}
{{< badge "CUDOS v5" >}}
{{< badge "CUR 2.0" >}}

## Bài toán kinh doanh

Dữ liệu thanh toán AWS rất chi tiết nhưng lại phân tán. Bộ phận tài chính cần số liệu tổng chi phí chính xác; đội ngũ kỹ thuật muốn biết rõ tài nguyên nào đang ngốn tiền; trong khi đó, các service owner lại cần những thông tin thực tế để có thể hành động ngay. Nếu không có một luồng phân tích chuẩn hóa, các team sẽ phải tự mò mẫm trong Cost Explorer hoặc tranh luận về những con số không đồng nhất do khác biệt về khung thời gian, cách tính toán, bộ lọc hay thời điểm làm mới (refresh) dữ liệu.

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
- Quy trình đối soát dữ liệu chặt chẽ giữa Athena và CUDOS;
- Cấu trúc hóa các thông tin FinOps, bao gồm: người chịu trách nhiệm, bằng chứng cụ thể, hành động cần làm và kết quả đạt được;
- Định nghĩa rõ cách phân bổ chi phí và các chỉ số unit economics;
- Thiết lập cảnh báo chi phí bất thường, quản lý phân quyền và vòng đời tài nguyên;
- Tích hợp một lớp AI (tùy chọn) để giải thích các dữ liệu đã được đối soát, tuyệt đối không dùng AI để thay thế số liệu gốc.

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
