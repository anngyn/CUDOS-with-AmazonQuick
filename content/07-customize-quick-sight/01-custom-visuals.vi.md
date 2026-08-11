---
title: "Thiết kế Dashboard tùy chỉnh trên QuickSight"
weight: 1
chapter: false
pre: "7.1 "
description: "Tạo các góc nhìn (view) tùy chỉnh tập trung vào việc ra quyết định FinOps mà không làm phá vỡ mô hình dữ liệu gốc của CUDOS."
services:
  - Amazon Quick Sight
  - CUDOS v5
---
{{< badge "Amazon Quick Sight" >}}
{{< badge "Thiết kế trực quan" >}}
{{< badge "FinOps" >}}

## Mục đích của Dashboard tùy chỉnh

CUDOS mặc định đã cung cấp một lượng thông tin khổng lồ về chi phí. Việc tạo một Dashboard tùy chỉnh (Custom Analysis) trên QuickSight giúp bạn "thu hẹp" đống dữ liệu đó lại để phục vụ riêng cho một bài toán/quyết định cụ thể của team bạn, thay vì phải copy/paste toàn bộ Dashboard gốc.

Một góc nhìn (view) chuẩn chỉnh cần trả lời được các câu hỏi sau:

```text
Phạm vi đang xem xét tốn bao nhiêu tiền?
Chi phí đó thay đổi thế nào theo từng ngày?
Dữ liệu đang được filter theo những Service và Account nào?
Dữ liệu hiển thị này được lấy lúc mấy giờ (đã mới nhất chưa)?
```

## Tiêu chuẩn của một Dashboard

Dashboard này được tạo từ dataset CUDOS chuẩn và xuất bản (publish) dưới tên `FinOps Project Dashboard`. Để nghiệm thu, nó phải có đủ các thành phần sau:

| Thành phần | Mục đích |
|---|---|
| Bộ lọc thời gian (Date control) | Xác định rõ khoảng thời gian đang xem xét |
| Tên chỉ số chi phí rõ ràng | Tránh nhầm lẫn giữa unblended/amortized/net |
| Bộ lọc Service | Giúp drill-down chi phí theo từng dịch vụ AWS |
| Bộ lọc Account | Giúp bóc tách chi phí theo từng team hoặc môi trường |
| Biểu đồ KPI | Hiển thị tổng tiền của kỳ hiện tại |
| Biểu đồ xu hướng (Trend) | Xem chi phí tăng giảm ra sao theo từng ngày |
| Dấu thời gian Refresh | Cho biết dữ liệu đang xem là bản mới nhất hay cũ |

## Lưu ý khi thiết kế

Tiêu đề của KPI phải ghi rõ loại chi phí, ví dụ: `Selected Period Unblended Cost`. TUYỆT ĐỐI tránh dùng những cái tên chung chung như `Total Cost` vì nó gây nhầm lẫn (không biết là đã chiết khấu hay chưa).

Biểu đồ xu hướng nên dùng trục X là Ngày, trục Y là cùng một loại chi phí với biểu đồ KPI. Chỉ nên gom nhóm (group by) theo Service nếu biểu đồ vẫn thoáng và dễ đọc.

Đảm bảo các bộ lọc (Filters) luôn hiển thị rõ ràng trên Dashboard để người khác có thể tự set lại đúng các filter đó và ra được con số y hệt như bạn.

## Ghi nhận Trạng thái

```text
Dashboard của dự án:
Dataset nguồn:
Chỉ số chi phí:
Trường ngày/múi giờ:
Bộ lọc và giá trị mặc định:
Trạng thái/thời gian làm mới:
Chủ sở hữu:
```

Lưu lại một ảnh chụp màn hình toàn cảnh Dashboard với đầy đủ thông tin bối cảnh. Đừng chụp lắt nhắt từng cái pop-up cấu hình bộ lọc.

{{< capture src="images/07-customize-quick-sight/07-01-finops-decision-dashboard.png" alt="Dashboard quyết định FinOps trên QuickSight đã phát hành, kèm ngữ cảnh phạm vi và độ mới dữ liệu" title="Chế độ xem quyết định FinOps đã phát hành" capture="Chụp dashboard đã phát hành ở trạng thái cuối cùng, với bộ điều khiển ngày, chỉ số chi phí có tên, bộ lọc dịch vụ và tài khoản, KPI của kỳ được chọn cùng dấu thời gian làm mới cuối cùng hiển thị trong một chế độ xem." caption="Giữ lại chế độ xem quyết định cuối cùng; cố ý bỏ qua các màn hình thiết lập bộ lọc và định dạng trực quan." >}}

{{< finops title="Điểm rút ra về FinOps" >}}
Dashboard tùy chỉnh giúp bạn tập trung vào quyết định của team mình, mà vẫn đảm bảo tính thống nhất với định nghĩa dữ liệu của công ty (dựa trên CUDOS).
{{< /finops >}}
