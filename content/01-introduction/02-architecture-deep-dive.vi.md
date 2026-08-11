---
title: "Kiến trúc & quyết định thiết kế"
weight: 2
chapter: false
pre: "1.2 "
description: "Hiểu từng lớp dữ liệu, phân tích, BI, AI và quản trị."
duration: "10 phút"
services:
  - AWS Data Exports
  - Amazon S3
  - AWS Glue
  - Amazon Athena
  - Amazon Quick Sight
  - Amazon Quick
---
{{< badge "Kiến trúc" >}}
{{< badge "FinOps" >}}


## Bối cảnh hệ thống

{{< evidence src="images/architecture/aws-finops-cudos-architecture.png" alt="Kiến trúc AWS FinOps Intelligence với CUR 2.0, S3, Glue, Athena, CUDOS v5, Amazon QuickSight, Amazon Quick, thông báo bất thường và quản trị" caption="Kiến trúc dự án: bằng chứng tài chính đi vào phân tích có thể tái lập, intelligence của CUDOS, hỗ trợ AI tùy chọn và hoạt động do con người quản trị." >}}

```text
                         AWS Billing
                             │
                             ▼
                      AWS Data Exports
                          CUR 2.0
                             │
                             ▼
                         Amazon S3
                             │
                             ▼
                     AWS Glue Catalog
                             │
                             ▼
                        Amazon Athena
                             │
                             ▼
                         CUDOS v5
                             │
                             ▼
                    Amazon Quick Sight
                             │
                             ▼
                        Amazon Quick
                     ┌───────┴────────┐
                     ▼                ▼
                 Chat Agent       Quick Flows
```


## Tại sao kiến trúc cần phân lớp

Kiến trúc này chủ động tách biệt rõ ràng các phần: nguồn cấp bằng chứng, nơi xử lý tính toán, lớp trình bày và phần giải thích dữ liệu. Điều này đảm bảo các công thức trên dashboard hay câu trả lời từ AI không thể làm sai lệch các số liệu tài chính gốc.

Mối quan hệ nhân quả được thể hiện rõ:

```text
Nếu dữ liệu CUR truyền về bị sai
→ Athena và CUDOS cũng sẽ sai theo.

Nếu dữ liệu giữa Athena và CUDOS không khớp
→ cần kiểm tra lại định nghĩa metric, phạm vi dữ liệu và trạng thái làm mới (refresh) trước khi tìm hiểu nguyên nhân từ góc độ kinh doanh.

Nếu kết quả từ AI khác với dữ liệu CUDOS/Athena đã được đối soát
→ câu trả lời của AI bị xem là không hợp lệ; trong mọi trường hợp, bản ghi tài chính gốc vẫn giữ nguyên.
```

## Dữ liệu tài chính gốc: AWS Billing và Data Exports

AWS Billing tạo ra các bản ghi chi phí và mức sử dụng. Tiếp đó, AWS Data Exports sẽ đóng gói các dữ liệu thanh toán này thành CUR 2.0 và chuyển đến lưu trữ tại S3.

Dự án sử dụng CUR 2.0 làm nguồn dữ liệu tài chính chuẩn (financial evidence) xuyên suốt hệ thống.

## Lưu trữ bền vững: Amazon S3

S3 đảm nhận việc lưu trữ dữ liệu Parquet. Kiến trúc này giúp tách biệt nơi lưu trữ dữ liệu chi phí dài hạn với các dashboard sử dụng chúng.

## Quản lý cấu trúc dữ liệu (Data Catalog): AWS Glue

Glue đóng vai trò cung cấp metadata (catalog) để Athena có thể hiểu và map các object trên S3 thành cấu trúc bảng và cột.

## Truy vấn và đối soát: Amazon Athena

Athena mang đến khả năng truy vấn SQL serverless trực tiếp trên dữ liệu CUR. Đây là nơi xác thực dữ liệu, kiểm tra các chiều phân tích chi phí và xây dựng các truy vấn tài chính nhất quán.

## Nền tảng phân tích FinOps: CUDOS v5

CUDOS là bảng điều khiển thông minh về AWS Cloud (Cloud Intelligence Dashboard). CUDOS tận dụng dữ liệu từ CUR/Athena và dataset của QuickSight để cung cấp các góc nhìn FinOps chuyên sâu cho ban điều hành, quản lý dịch vụ, theo dõi tài nguyên, cam kết sử dụng (commitment) và tối ưu hóa.

## Công cụ trực quan hoá (BI): Amazon QuickSight

QuickSight đóng vai trò là nền tảng BI cốt lõi. Dịch vụ này cung cấp các tính năng như dataset, SPICE, analysis, visual, filter, control và các dashboard hoàn chỉnh.

## Trợ lý ảo AI: Amazon Q

Amazon Q bổ sung khả năng phân tích bằng ngôn ngữ tự nhiên, Space, chat agent và Flow. Cần lưu ý rằng Q chỉ nên dùng để truy vấn các dữ liệu đã được đối soát, chứ không phải là nơi thực hiện các phép tính tài chính chính thức.

## Ranh giới trách nhiệm

| Lớp | Trách nhiệm |
|---|---|
| CUR 2.0 | Bằng chứng tài chính |
| S3 | Lưu trữ bền vững |
| Glue | Metadata/catalog |
| Athena | Truy vấn và tính toán ngữ nghĩa |
| CUDOS | AWS FinOps intelligence |
| Amazon QuickSight | BI và trực quan hóa |
| Amazon Q | Phân tích hội thoại và workflow |

## Các quyết định thiết kế chính

| Quyết định | Lý do | Tác động vận hành |
|---|---|---|
| Dùng CUR 2.0 định dạng Parquet | Cung cấp số liệu thanh toán chi tiết, lưu trữ tối ưu và truy vấn hiệu quả | Việc xác thực qua Athena hoàn toàn độc lập với dashboard |
| Triển khai trên một tài khoản trước | Giảm thiểu độ phức tạp về nguồn dữ liệu và phân quyền IAM trong giai đoạn PoC | Sẽ mở rộng khả năng tổng hợp dữ liệu từ nhiều tài khoản (multi-account) sau |
| Dùng Athena làm lớp đối soát | SQL minh bạch, dễ dàng kiểm tra và lặp lại | Giúp đối chiếu và xác minh tính chính xác của dữ liệu hiển thị trên dashboard |
| Ưu tiên dùng CUDOS thay vì tự làm BI | Tận dụng ngay các logic FinOps đã được AWS xây dựng sẵn | Các visual tùy chỉnh sau này chỉ cần tập trung vào việc ra quyết định thay vì phải xây dựng lại toàn bộ model |
| Chỉ cấp quyền đọc cho phân tích | Theo dõi chi phí mà không tác động đến hệ thống đang chạy | Giảm thiểu phạm vi ảnh hưởng (blast radius) nếu tài khoản BI hoặc AI bị lộ |
| Yêu cầu con người phê duyệt khắc phục | Các gợi ý từ hệ thống thường không nắm rõ toàn bộ bối cảnh của workload | Quyết định thay đổi tài nguyên vẫn do người quản lý kỹ thuật và nghiệp vụ trực tiếp đưa ra |

{{< security >}}
Hệ thống phân tích chủ yếu được cấp quyền đọc. Việc giám sát chi phí không yêu cầu quyền chỉnh sửa vào các workload phát sinh chi phí đó.
{{< /security >}}

## Tài liệu tham chiếu chính thức

- https://docs.aws.amazon.com/guidance/latest/cloud-intelligence-dashboards/cudos-cid-kpi.html
- https://docs.aws.amazon.com/quick/latest/userguide/what-is.html
