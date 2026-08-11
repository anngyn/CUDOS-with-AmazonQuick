---
title: "Kiểm tra Glue Catalog, Schema và Truy vết S3"
weight: 2
chapter: false
pre: "4.2 "
description: "Tìm hiểu cách AWS Glue định hướng dữ liệu cho Athena và giúp CUDOS lấy đúng nguồn dữ liệu CUR Parquet."
services:
  - AWS Glue
  - Amazon S3
  - Amazon Athena
---
{{< badge "AWS Glue" >}}
{{< badge "Data Catalog" >}}
{{< badge "Amazon S3" >}}

## Vai trò của Glue Data Catalog

Glue đóng vai trò là "cuốn danh bạ" kết nối giữa Kho lưu trữ (S3) và Lớp tính toán (Athena). Glue sẽ nói cho Athena biết: Dữ liệu đang nằm ở thư mục S3 nào, và từng cột trong file Parquet mang ý nghĩa gì.

Nếu Catalog bị trỏ nhầm thư mục, lệnh SQL của bạn vẫn chạy thành công (không báo lỗi), nhưng dữ liệu trả ra sẽ bị sai lệch hoặc thiếu hụt. Do đó, kiểm tra Glue Catalog là bước rà soát dữ liệu cực kỳ quan trọng.

## Thông tin Catalog thực tế

Lấy tên Database thực tế mà bạn đã tạo. Trong ví dụ này là `cid_data_export`; ảnh Athena đại diện ở 4.1 là đủ vì Athena phải resolve database và table trong Glue trước khi chạy được query.

Các thông tin cần ghi nhận:

```text
Database Glue:
Table Glue:
Vị trí table trên S3:
Định dạng input/output:
Mô hình phân vùng:
Phân vùng billing hiện tại:
```

## Cấu trúc Schema chuẩn

Bảng (Table) dữ liệu phải có đủ các nhóm cột quan trọng phục vụ phân tích tài chính:

- hóa đơn và kỳ lập hóa đơn;
- line item và account sử dụng;
- sản phẩm/dịch vụ và định giá;
- reservation và Savings Plans;
- resource tags và Cost Categories;
- các trường chi phí được dùng bởi những chỉ số đã chọn.

Lưu ý: Không phải cột nào cũng có dữ liệu (có thể bị Null). Tùy vào loại dịch vụ và dòng chi phí (line item) mà bạn phải viết SQL linh hoạt để xử lý các dữ liệu trống (sparse data) này.

## Truy vết đường dẫn S3 (Data Lineage)

Trường `Location` (vị trí S3) trong Glue Table bắt buộc phải trùng khớp hoàn toàn với đường dẫn Prefix của Data Exports mà chúng ta đã cấu hình ở Chương 3:

```text
Đích Data Export
        ↓ phải khớp
Glue table Location
        ↓ được diễn giải bởi
Athena table
        ↓ được các dataset CUDOS sử dụng
```

```text
Database Glue:
Table Glue:
Vị trí table trên S3:
Prefix bàn giao đã xác thực:
Vị trí khớp: yes/no
Trạng thái lineage: PASS / INVESTIGATE
```

{{< finops title="Kết luận FinOps" >}}
Bạn không thể tin tưởng một biểu đồ Dashboard đẹp đẽ nếu không biết chính xác dữ liệu của nó được lấy từ thư mục S3 nào. Việc truy vết này (Data Lineage) là bắt buộc.
{{< /finops >}}
