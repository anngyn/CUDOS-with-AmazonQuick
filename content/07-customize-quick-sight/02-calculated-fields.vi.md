---
title: "Tính toán tùy chỉnh (Calculated Fields) và Ranh giới dữ liệu"
weight: 2
chapter: false
pre: "7.2 "
description: "Biết cách dùng Calculated Fields trên QuickSight để tạo các hiển thị tùy chỉnh (presentation logic) mà không làm hỏng dữ liệu gốc (semantic layer)."
services:
  - Amazon Quick Sight
  - Calculated Fields
---
{{< badge "Amazon Quick Sight" >}}
{{< badge "Trường tính toán" >}}
{{< badge "Quản trị ngữ nghĩa" >}}

## Ranh giới giữa Trình bày và Dữ liệu gốc

Tính năng Calculated Fields của QuickSight chỉ nên dùng cho các tác vụ "làm đẹp" hoặc phân loại hiển thị trên bề mặt (presentation logic). TUYỆT ĐỐI KHÔNG dùng tính năng này để định nghĩa lại các quy tắc chia tiền phức tạp như Amortized Cost, Chargeback hay Allocation, vì những logic ngầm này sẽ bị chôn giấu trong Dashboard và không ai khác tái sử dụng được.

```text
Các quy tắc tính tiền xài chung (Reusable logic)
→ Nên để ở mức Athena view hoặc Data Catalog.

Các phân loại hiển thị bề mặt (Local UI logic)
→ Dùng Calculated Fields trên QuickSight.
```

## Ví dụ: Tạo phân loại Spend Band

Giả sử bạn muốn tạo một trường Calculated Field tên là `Spend Band` (Nhóm chi tiêu) cực kỳ đơn giản:

```text
ifelse(
    {net_unblended_cost} >= 15,
    'High Spend',
    'Standard Spend'
)
```

Cần ghi rõ ngưỡng (threshold) `$15` và trường gốc là `net_unblended_cost`. Trong dashboard minh họa, dòng EC2 production theo ngày nằm trên ngưỡng, còn RDS, Lambda, S3, Data Transfer và staging nằm dưới ngưỡng. Trường này chỉ giúp phân loại (gắn mác) cho Dashboard dễ nhìn hơn, chứ KHÔNG hề làm thay đổi con số tiền bạc thực tế.

## Xác thực logic (Testing)

Bạn phải tự test bằng mắt ít nhất 2 trường hợp: một giá trị nằm dưới ngưỡng và một giá trị nằm trên ngưỡng, xem QuickSight có gắn đúng mác (band) không. Bản ghi kiểm chứng chứa giá trị đầu vào, band dự kiến, band quan sát được và kết quả.

```text
Trường tính toán:
Trường gốc:
Ngưỡng cấu hình:
Test case 1 (dưới ngưỡng):
Test case 2 (trên ngưỡng):
Kết quả: PASS / FAIL
```

{{< capture src="images/07-customize-quick-sight/07-01-finops-decision-dashboard.png" alt="Kiểm chứng Spend Band trên QuickSight với các giá trị ở hai phía của ngưỡng" title="Kiểm chứng ranh giới trường tính toán" capture="Dùng lại ảnh dashboard FinOps Decision Dashboard [Synthetic] ở mục 7.1. Bảng scope thể hiện ít nhất một dòng EC2 production từ $15 trở lên có nhãn High Spend và các dòng chi phí thấp hơn có nhãn Standard Spend. Không dùng trình chỉnh sửa calculated field làm bằng chứng." caption="Hai nhóm minh họa quy tắc trình bày cục bộ mà không coi quy tắc này là một định nghĩa tài chính dùng chung." >}}

{{< validation >}}
Logic tính toán bề mặt chỉ được nghiệm thu khi nó rõ ràng, chỉ dùng trong nội bộ cái Dashboard đó, có thể test bằng tay dễ dàng, và quan trọng nhất là KHÔNG giẫm chân lên các quy tắc chia tiền chuẩn của tổ chức.
{{< /validation >}}
