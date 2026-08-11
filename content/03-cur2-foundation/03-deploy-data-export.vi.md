---
title: "Triển khai Thu thập dữ liệu và CUR 2.0"
weight: 3
chapter: false
pre: "3.3 "
description: "Ghi nhận kiến trúc triển khai CID tiêu chuẩn, các tham số (parameter), phân quyền IAM và các tài nguyên sẽ được tạo ra."
services:
  - AWS CloudFormation
  - AWS Data Exports
  - Amazon S3
  - AWS Glue
  - Amazon Athena
---
{{< badge "AWS CloudFormation" >}}
{{< badge "AWS Data Exports" >}}
{{< badge "CUR 2.0" >}}

## Phương pháp triển khai

Dự án này sử dụng trực tiếp CloudFormation template chuẩn của AWS Cloud Intelligence Dashboards (CID) thay vì tự maintain một bản sao (fork) riêng. Tài liệu gốc của AWS luôn là nguồn tham chiếu chuẩn xác nhất:

`https://docs.aws.amazon.com/guidance/latest/cloud-intelligence-dashboards/data-exports.html`

Quyết định này giúp giảm thiểu việc phải tự viết code hạ tầng (IaC), nhưng bù lại bạn phải theo dõi sát sao version của template và ghi nhận chính xác các parameter đã nhập vào CloudFormation.

{{< evidence src="images/03-cur2/2.%20launchstack.png" alt="Hướng dẫn CID Data Exports chính thức với nút Launch Stack" caption="Nên dùng hướng dẫn chính thức của CID làm điểm bắt đầu triển khai, tránh sao chép URL của các template cũ." >}}

## Các tham số cấu hình (Parameters)

Stack có tên `CID-DataExports-Destination`. Source Account và Destination Account đều dùng account hiện tại:

```text
Destination Account ID = <ACCOUNT_ID>
Source Account IDs      = <ACCOUNT_ID>
Manage CUR 2.0          = yes
FOCUS                    = no
Cost Optimization Hub   = no
Carbon export            = no
```

Trong lần này, chúng ta chỉ bật CUR 2.0 vì nó chứa đủ bộ dữ liệu mà CUDOS cần. Các tùy chọn như FOCUS, Cost Optimization Hub hay Carbon tạm thời không được chọn để cấu trúc dữ liệu ban đầu gọn gàng và dễ test nhất.

{{< evidence src="images/03-cur2/3.destinationfordataexport.png" alt="Các parameter CloudFormation cho destination stack Data Exports" caption="Bộ parameter tham khảo cho kiến trúc Single-account." >}}

## IAM và Ranh giới phân quyền

Template sẽ tự tạo các IAM Role và Managed Policy cần thiết để xuất dữ liệu và cập nhật catalog tự động. Việc bạn tick chọn ô xác nhận capability trên CloudFormation chỉ cho phép nó tạo các Role này, chứ không đảm bảo nguyên tắc đặc quyền tối thiểu (least privilege). Chúng ta sẽ rà soát lại các Role này ở Chương 11.

{{< evidence src="images/03-cur2/4.createstack.png" alt="Xác nhận capability IAM của CloudFormation và nút Create stack" caption="Hãy ghi nhận các capability IAM được cấp phát; các IAM role này vẫn phải được rà soát lại sau này." >}}

## Các tài nguyên được sinh ra

Destination stack dự kiến sẽ tạo ra:

- 1 S3 bucket để lưu dữ liệu đích;
- Cấu hình CUR 2.0 Data Export;
- Các job tự động tạo database và table trên Glue;
- Phân vùng metadata tương thích với Athena;
- Các IAM Policy phục vụ cho việc gửi và truy vấn dữ liệu.

Khi CloudFormation báo trạng thái `CREATE_COMPLETE`, nó chỉ chứng minh các tài nguyên hạ tầng đã tạo thành công. Nó KHÔNG có nghĩa là dữ liệu Billing đã thực sự chảy về S3. Việc xác thực luồng dữ liệu này sẽ được thực hiện ở bước sau.

## Ghi nhận trạng thái triển khai

```text
Template/version do CloudFormation hiển thị:
Region: ap-southeast-2
Tên stack: CID-DataExports-Destination
Topology source/destination: một account
CUR 2.0 enabled: yes
Trạng thái stack cuối:
Resource thất bại đầu tiên/lý do status (nếu có):
```

Nếu Stack bị lỗi, hãy tìm resource bị lỗi đầu tiên và đọc nguyên nhân (status reason) của nó. Tuyệt đối không dùng quyền Administrator để chạy lại hòng "lách" lỗi, vì như vậy sẽ che lấp mất nguyên nhân gốc rễ gây ra lỗi.

{{< validation >}}
Hệ thống hạ tầng được nghiệm thu khi CloudFormation báo `CREATE_COMPLETE`, số lượng tài nguyên tạo ra chuẩn xác và các parameter đã được ghi chép đầy đủ. Quá trình kiểm tra dữ liệu Billing sẽ là một bước xác thực riêng biệt.
{{< /validation >}}
