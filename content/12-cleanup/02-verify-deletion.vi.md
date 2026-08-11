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


Báo dòng chữ "Deleted successfully" trên màn hình không có nghĩa là tài nguyên đã bốc hơi 100%. Bạn phải check lại trên AWS Console, và quan trọng nhất: Chờ Bill tháng sau về xem có bị tính tiền nữa không.


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

{{< capture src="images/12-cleanup/12-01-final-resource-inventory.png" alt="Inventory cuối cùng của tài nguyên dự án với trạng thái đã xóa và được giữ lại" title="Inventory vòng đời cuối cùng" capture="Chụp inventory tài nguyên đã đối soát, thể hiện mọi stack, export, bucket hoặc prefix dữ liệu được giữ lại, tài sản Glue/Athena, tài sản Quick, anomaly monitor, SNS topic và chat mapping được tạo cho dự án, cùng trạng thái DELETED hoặc RETAINED, chủ sở hữu, lý do và chi phí định kỳ dự kiến." caption="Một inventory vòng đời duy nhất thay thế các ảnh chụp xóa riêng lẻ từ từng AWS console." >}}

## Check lại Billing (Hậu kiểm)

AWS tính tiền có độ trễ (delay từ 24-48h). Do đó, sau khi dọn dẹp vài ngày, HÃY VÀO LẠI BILLING để xem có khoản tiền rác (vd: tiền lưu trữ EBS Snapshot, IP tĩnh chưa release, S3 versioning) nào còn sót lại không.

{{< validation >}}
Dự án chỉ "Done" khi: 1 là Xóa sạch, 2 là Giữ lại thì phải có người nhận Trách nhiệm trả tiền.
{{< /validation >}}

{{< finops title="Điểm rút ra về FinOps" >}}
Dọn dẹp rác (Lifecycle Management) CHÍNH LÀ FinOps. Thấy một cục tài nguyên vô danh vứt lăn lóc và đặt câu hỏi "Cái của nợ này của ai? Sao giờ này nó vẫn chạy?" là thao tác tối ưu chi phí hiệu quả nhất.
{{< /finops >}}
