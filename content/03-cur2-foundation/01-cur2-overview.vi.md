---
title: "Sử dụng CUR 2.0 làm dữ liệu gốc đối soát"
weight: 1
chapter: false
pre: "3.1 "
description: "Giải thích lý do CUR 2.0 được chọn làm nguồn dữ liệu chuẩn cho dự án (Source of Truth) và cách thức phân phối dữ liệu của nó."
duration: "10 phút"
services:
  - AWS Data Exports
  - CUR 2.0
  - Amazon S3
---
{{< badge "CUR 2.0" >}}
{{< badge "AWS Data Exports" >}}
{{< badge "Amazon S3" >}}


## CUR 2.0 là gì?

CUR 2.0 (Cost and Usage Report 2.0) là bộ dữ liệu chi tiết nhất về chi phí và mức độ sử dụng tài nguyên AWS, được phân phối thông qua dịch vụ AWS Data Exports. Dataset này bao gồm thông tin chi tiết về hóa đơn (billing), từng dòng chi phí (line-item), thông tin sản phẩm, bảng giá, các gói Reservation/Savings Plans, cũng như các Tag tài nguyên và Cost Category.

Dữ liệu sẽ được tự động điền vào các trường (field) tương ứng tùy thuộc vào loại chi phí và từng AWS Service cụ thể.

## Kiến trúc Thu thập dữ liệu

```text
AWS account của dự án (một account)
        │
        ├── Source: AWS Billing / Data Exports
        │
        └── Destination: Data Collection
                ├── S3 bucket
                ├── Glue database/table
                └── Lớp truy vấn Athena
```


## Vì sao nên dùng CUR thay vì chỉ xem dữ liệu trên Dashboard?

CUDOS và QuickSight thực chất chỉ là lớp trình bày (consumer) lấy dữ liệu để hiển thị. Bạn vẫn cần CUR 2.0 làm "lớp dữ liệu gốc" (Source of Truth) lưu trữ lâu dài để đối soát, chạy truy vấn SQL tùy chỉnh, xây dựng công cụ BI, phân tích chuyên sâu hoặc cấp dữ liệu cho các hệ thống khác trong tương lai.

## Định dạng Parquet

Cơ chế thu thập của AWS Data Exports sẽ lưu dữ liệu phân tích dưới định dạng Parquet. Đây là định dạng lưu trữ theo cột (columnar), giúp Athena chạy truy vấn (query) hiệu quả hơn, tốc độ đọc nhanh hơn và tốn ít chi phí quét (scan) hơn hẳn so với định dạng văn bản theo hàng (như CSV hoặc JSON).

## Thời gian phân phối dữ liệu (Data Delivery)

Xin lưu ý: AWS thông báo rằng lần xuất dữ liệu (delivery) đầu tiên của Data Exports thường mất khoảng 24 giờ, đôi khi có thể lên đến 72 giờ. Bạn cần đưa độ trễ này vào kế hoạch dự án thực tế để tránh việc ngồi chờ dữ liệu một cách vô ích.

## Lưu ý về FinOps

Hãy chủ động kích hoạt và quản lý Cost Allocation Tags cùng Cost Categories trước khi bạn muốn chia tiền (phân bổ chi phí) cho từng team hay từng sản phẩm cụ thể. Dữ liệu CUR sẽ KHÔNG TỰ ĐỘNG sinh ra các cột như `team` hay `project` nếu tổ chức của bạn không thiết lập sẵn hệ thống đánh tag chuẩn (taxonomy).

{{< finops title="Điểm rút ra về FinOps" >}}
Dashboard tốt phải bắt nguồn từ một bộ dữ liệu chi phí chuẩn chỉnh. Hãy xây dựng lớp thu thập dữ liệu (Data Collection) thật vững chắc trước khi thiết kế các KPI phức tạp.
{{< /finops >}}

## Tài liệu tham chiếu chính thức

https://docs.aws.amazon.com/guidance/latest/cloud-intelligence-dashboards/data-exports.html
