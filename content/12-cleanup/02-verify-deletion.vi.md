---
title: "Nghiệm thu dọn dẹp và Check lại Billing"
weight: 2
chapter: false
pre: "12.2 "
description: "Kiểm tra xem đã xóa sạch thực sự chưa, và đợi vài ngày sau check lại Billing xem có khoản tiền \"ma\" nào bị rò rỉ không."
duration: "5–10 phút"
services:
  - AWS CloudFormation
  - Amazon S3
  - Amazon Quick
  - AWS Billing
---
{{< badge "Xác thực" >}}
{{< badge "Dọn dẹp" >}}
{{< badge "FinOps" >}}


Thông báo "Deleted successfully" không đủ để xác nhận vòng đời đã hoàn tất. Cần đối chiếu lại trên AWS Console và kiểm tra billing sau khi dữ liệu chi phí đã kịp cập nhật.


## Check CloudFormation

Đảm bảo Stack của Data Exports đã bay màu.


## Check Data Exports

Vào console Data Exports xem cái export của mình đã biến mất chưa.


## Check S3 và Glue

Kiểm tra các tài nguyên S3 và Glue thuộc dự án đã được xóa hoặc được chủ ý giữ lại.

## Check Amazon Q và QuickSight

Kiểm tra:

- Spaces
- chat agents
- Flows
- Datasets
- Analyses
- Dashboards
- capacity/usage của SPICE


## Check Cost Anomaly Detection và SNS

Kiểm tra:

- subscription/monitor của Cost Anomaly Detection
- SNS topic
- ánh xạ Slack/chat

## Biên bản Bàn giao Tài nguyên giữ lại (Retained Resources)

```text
Tài nguyên:
Lý do giữ lại:
Chủ sở hữu:
Chi phí định kỳ dự kiến:
Ngày rà soát tiếp theo:
```

Lập một cái bảng Excel (Inventory) danh sách tất cả tài nguyên, đánh dấu `DELETED` hoặc `RETAINED`, chụp lại màn hình cái bảng đó làm biên bản nghiệm thu. Không cần chụp 100 tấm ảnh rác cho từng màn hình AWS Console.

## Inventory hiện tại đang giữ lại

Dự án được chủ động giữ lại trong khi evidence đang được rà soát. Inventory CLI chỉ-đọc ngày 12/08/2026 xác nhận:

| Nhóm tài sản | Bằng chứng trực tiếp | Trạng thái | Chủ sở hữu | Lý do / lần review tới |
|---|---|---|---|---|
| Nền tảng dữ liệu | `CID-DataExports-Destination` là `CREATE_COMPLETE`; Athena/Glue lõi còn tồn tại | RETAINED | Project owner | Nền tảng CUDOS; review 01/09/2026 |
| Dashboard, analysis, dataset Quick | CUDOS v5 và các tài sản CUDOS/FinOps tùy chỉnh đang được liệt kê | RETAINED | Project owner | Evidence dự án và Direct Query analytics; review 01/09/2026 |
| Q&amp;A và Flow | Topic Q&amp;A tổng hợp đã index; Flow có quản trị còn Draft và đã xuất report | RETAINED | Project owner | Evidence mục 8–9; review 01/09/2026 |
| Cảnh báo | Service monitor, subscription `$10` immediate và SNS topic tồn tại; chưa có endpoint nhận | RETAINED | Project owner | Detector đang học và chờ routing; review 01/09/2026 |

Không được ghi chi phí định kỳ là bằng 0: S3 storage/request, Athena scan, Amazon Quick entitlement và SNS delivery sau này đều vẫn theo pricing AWS. Chưa có lệnh xóa nào được cấp quyền hoặc thực hiện.

{{< capture src="images/12-cleanup/12-01-final-resource-inventory.svg" alt="Inventory CLI đã làm sạch về tài nguyên dự án đang được giữ lại" title="Inventory tài nguyên trước teardown" capture="Inventory CLI trực tiếp đã làm sạch, thể hiện nền tảng dự án, tài sản Amazon Quick, anomaly monitor và SNS topic. Mọi dòng đều là RETAINED vì chưa được cấp quyền teardown." caption="Đây là inventory trước teardown, không phải bằng chứng xóa. Nó thay thế các ảnh console rời rạc nhưng vẫn giữ quyết định retain-or-delete rõ ràng." >}}

[Tải inventory máy có thể đọc](/data/audits/12-01-retained-resource-inventory.json)

## Check lại Billing (Hậu kiểm)

AWS tính tiền có độ trễ (delay từ 24-48h). Do đó, sau khi dọn dẹp vài ngày, HÃY VÀO LẠI BILLING để xem có khoản tiền rác (vd: tiền lưu trữ EBS Snapshot, IP tĩnh chưa release, S3 versioning) nào còn sót lại không.

{{< validation >}}
Tài liệu vòng đời chỉ hoàn tất khi mọi tài nguyên đã xóa hoặc được ghi rõ là chủ động giữ lại. Teardown thực tế vẫn chưa hoàn tất cho đến khi chủ sở hữu cấp quyền xóa và inventory hậu kiểm xác nhận trạng thái cuối.
{{< /validation >}}

{{< finops title="Điểm rút ra về FinOps" >}}
Quản lý vòng đời là một phần của FinOps. Câu hỏi quan trọng là: tài nguyên này thuộc ai, vì sao còn tồn tại và khi nào sẽ được review hoặc xóa?
{{< /finops >}}
