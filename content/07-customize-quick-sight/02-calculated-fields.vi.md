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
    {unblended_cost} >= 1000,
    'High Spend',
    'Standard'
)
```

Bạn cần note lại rõ ràng ngưỡng (threshold) là 1000 và trường gốc là `unblended_cost`. Trường này chỉ giúp bạn phân loại (gắn mác) cho Dashboard dễ nhìn hơn, chứ nó KHÔNG hề làm thay đổi con số tiền bạc thực tế.

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

{{< capture src="images/07-customize-quick-sight/07-02-spend-band-validation.png" alt="Kiểm chứng Spend Band trên QuickSight với các giá trị ở hai phía của ngưỡng" title="Kiểm chứng ranh giới trường tính toán" capture="Chụp một visual dạng bảng nhỏ thể hiện ít nhất một đầu vào dưới ngưỡng và một đầu vào tại hoặc trên ngưỡng, đồng thời hiển thị Spend Band quan sát được và kết quả dự kiến. Không dùng trình chỉnh sửa trường tính toán làm bằng chứng." caption="Hai trường hợp tại ranh giới minh họa quy tắc trình bày mà không coi quy tắc này là một định nghĩa tài chính dùng chung." >}}

{{< validation >}}
Logic tính toán bề mặt chỉ được nghiệm thu khi nó rõ ràng, chỉ dùng trong nội bộ cái Dashboard đó, có thể test bằng tay dễ dàng, và quan trọng nhất là KHÔNG giẫm chân lên các quy tắc chia tiền chuẩn của tổ chức.
{{< /validation >}}
