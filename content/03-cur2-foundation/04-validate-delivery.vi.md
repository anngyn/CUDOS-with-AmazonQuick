---
title: "Kiểm tra luồng dữ liệu và Độ trễ cập nhật"
weight: 4
chapter: false
pre: "3.4 "
description: "Xác minh dữ liệu CUR 2.0 (định dạng Parquet) đã được ghi thành công vào thư mục S3 và hiểu rõ về độ trễ (freshness) của dữ liệu."
services:
  - AWS Data Exports
  - Amazon S3
  - CUR 2.0
---
{{< badge "AWS Data Exports" >}}
{{< badge "Amazon S3" >}}
{{< badge "CUR 2.0" >}}

## Mục đích xác thực

Bước này nhằm trả lời một câu hỏi duy nhất: Dữ liệu CUR 2.0 thực tế đã được AWS xuất về đúng thư mục S3 để hệ thống Dashboard lấy lên sử dụng hay chưa?

Như đã nói, CloudFormation chạy thành công là chưa đủ. Bạn có thể phải đợi vài giờ đồng hồ thì file dữ liệu Billing đầu tiên mới xuất hiện trên S3.

## Cấu trúc thư mục chuẩn

Pattern collection chính thức tạo ra một path tương tự:

```text
s3://<prefix>-<destination-account-id>-data-exports/
    <export-name>/<source-account-id>/<export-name>/data/
    <billing-period>/*.parquet
```

Các điều kiện bắt buộc:

- Loại dữ liệu Export phải là CUR 2.0;
- Đích đến phải khớp chuẩn xác với S3 Bucket đã tạo;
- Phải xuất hiện thư mục phân vùng (partition) của tháng tính cước hiện tại;
- Trong thư mục đó phải có ít nhất một file `.parquet`;
- Thời gian (timestamp) tạo file phải khớp với lần Data Exports chạy gần nhất.

## Thu thập bằng chứng thực tế

{{< evidence src="images/03-cur2/03-12-cur2-parquet-delivery.png" alt="Phân vùng kỳ billing trên S3 chứa object CUR 2.0 Parquet" caption="Kết quả quan sát được: phân vùng billing hiện tại chứa một object CUR 2.0 Parquet thật." >}}

Việc lưu lại thông tin text (dễ copy/paste) sẽ có giá trị kiểm chứng cao hơn là đi chụp màn hình từng bước click chuột trên S3:

```text
Tên export:
Bucket/prefix:
Phân vùng billing:
Số object:
Timestamp object mới nhất:
Trạng thái validation: PASS / FAIL
```

## Độ trễ của dữ liệu (Data Freshness)

AWS thông báo rằng lần xuất dữ liệu (delivery) đầu tiên thường mất 24 giờ, đôi khi lên tới 72 giờ. Do đó, nếu bạn thấy thư mục S3 trống trơn trong khoảng thời gian này thì đó là chuyện bình thường (đang chờ), chứ không phải do bạn cài đặt sai.

Độ trễ này cũng ảnh hưởng đến việc xem dữ liệu: Athena luôn query trực tiếp trên S3 nên sẽ thấy dữ liệu mới nhất, trong khi Dashboard trên CUDOS (dùng SPICE) chỉ cập nhật dữ liệu sau khi được refresh (thường là 1 lần/ngày).

## Xử lý Dữ liệu lịch sử cũ (Backfill)

Bạn có thể gửi Ticket cho AWS Support để yêu cầu đẩy lại dữ liệu CUR của các tháng cũ (backfill). Đây là tính năng tùy chọn (phụ thuộc vào Support Plan) và không bắt buộc phải làm để chứng minh tính khả thi của dự án.

{{< security >}}
Tên Bucket và đường dẫn Prefix có thể vô tình làm lộ Account ID. Do đó, nếu bạn cần public các tài liệu, hãy che đi (redact) các thông tin nhạy cảm này.
{{< /security >}}

{{< finops title="Điểm rút ra về FinOps" >}}
Thành quả đáng tin cậy đầu tiên của hệ thống FinOps không phải là cái Dashboard đẹp mắt; mà chính là một bộ dữ liệu tài chính chuẩn xác, có timestamp rõ ràng và nằm ngoan ngoãn trong đúng thư mục S3 đã chỉ định.
{{< /finops >}}
