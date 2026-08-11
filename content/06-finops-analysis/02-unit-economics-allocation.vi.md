---
title: "Tỷ lệ phân bổ chi phí và Unit Economics"
weight: 2
chapter: false
pre: "6.2 "
description: "Xác định tỷ lệ chi phí đã được phân bổ thành công cho các owner và kết nối chi phí này với các chỉ số kinh doanh thực tế."
services:
  - CUR 2.0
  - Cost Allocation Tags
  - Cost Categories
  - FinOps
---
{{< badge "Unit Economics" >}}
{{< badge "Cost Allocation" >}}
{{< badge "FinOps" >}}

## Mô hình quản lý Ownership

Việc phân bổ (allocation) giúp xác định rõ ai là người chịu trách nhiệm cho từng khoản chi phí. Cấu trúc phân bổ có thể được xây dựng dựa trên Linked Accounts, Cost Categories, Cost Allocation Tags, hoặc phân cấp theo Team, Sản phẩm, Ứng dụng và Môi trường.

Chỉ nên chọn một chiều (dimension) duy nhất làm tiêu chuẩn để báo cáo ownership. Nếu bạn trộn lẫn giữa `Team`, `CostCenter` và `Application` mà không có quy tắc ưu tiên rõ ràng, cùng một khoản chi phí có thể bị tính trùng lặp hoặc được quy cho nhiều nơi khác nhau.

```text
Chiều ownership chính:
Chiều dự phòng (Fallback):
Các giá trị hợp lệ:
Xử lý các giá trị không xác định (Unknown/Unallocated):
Cơ cấu tổ chức (Owner taxonomy):
Chu kỳ rà soát:
```

## Định nghĩa tỷ lệ phân bổ thành công (Allocation Coverage)

Dự án cần phân biệt rõ ràng giữa "chi phí cần phân bổ" (allocable cost) và tổng chi phí trên hóa đơn. Các khoản như Thuế (Tax), Phí hỗ trợ (Support), Credits hoặc các dịch vụ dùng chung (Shared Services) có thể được loại trừ khỏi danh sách cần phân bổ, nhưng mọi ngoại lệ đều phải được ghi nhận rõ ràng.

```text
Chi phí đã phân bổ = chi phí có gắn tag ownership hoặc Cost Category hợp lệ
 
Tỷ lệ phân bổ (%) = (chi phí đã phân bổ / tổng chi phí cần phân bổ) × 100%

Chi phí chưa phân bổ = tổng chi phí cần phân bổ - chi phí đã phân bổ
```

Nếu không định nghĩa rõ thế nào là "chi phí cần phân bổ", hai team khác nhau có thể tính ra hai tỷ lệ phân bổ (coverage) hoàn toàn khác nhau dù dùng chung một bảng dữ liệu CUR.

## Xử lý chi phí dùng chung (Shared Services)

Chi phí của các dịch vụ dùng chung không nên bị âm thầm gán đại cho một product team nào đó. Dự án cần thống nhất và ghi nhận lại một trong các cách xử lý sau:

- Giữ nguyên thành chi phí nền tảng chung (Platform/Central cost);
- Phân bổ lại dựa trên mức độ sử dụng thực tế của từng team (nếu đo lường được);
- Chia đều theo một tỷ lệ cố định đã được các bên đồng ý;
- Tạm thời để ở trạng thái "chưa phân bổ" và theo dõi như một technical nợ (backlog) về chất lượng dữ liệu.

Các quy tắc phân bổ, người phụ trách, ngày bắt đầu áp dụng và lý do thay đổi phải được lưu lại lịch sử (versioning), vì bất kỳ thay đổi nào trong quy tắc cũng sẽ làm thay đổi số liệu báo cáo của các tháng trước.

## Định nghĩa Unit Economics

Unit Economics là sự kết hợp giữa chi phí cloud đã được phân bổ và một chỉ số kinh doanh cụ thể:

```text
Chi phí đơn vị (Unit cost) = Chi phí của workload đã phân bổ / Tổng khối lượng công việc kinh doanh (đã xác minh)
```

Chỉ số kinh doanh (mẫu số) cũng cần có định nghĩa rõ ràng:

```text
Tên chỉ số kinh doanh:
Hệ thống/Bảng dữ liệu gốc:
Người cung cấp số liệu (Owner):
Chu kỳ và múi giờ tổng hợp:
Tần suất làm mới (Refresh):
Khóa kết nối (Join key) hoặc quy tắc mapping:
Quy tắc kiểm tra chất lượng số liệu:
Các trường hợp ngoại lệ đã biết:
```

Ví dụ minh họa:

```text
Tổng chi phí hệ thống Inference (tháng) = $1.200
Số lượng request inference thành công = 600.000
Chi phí cho mỗi 1.000 request thành công = $2,00
```

*(Lưu ý: Ví dụ trên chỉ để minh họa công thức, không phải là số liệu thực tế của dự án). Việc sử dụng "tổng số lần gọi API" làm mẫu số trong khi nghiệp vụ yêu cầu "số request thành công" có thể tạo ra cảm giác hệ thống đang hoạt động hiệu quả hơn, trong khi thực tế số lượng lỗi (error) lại đang tăng lên.*

{{< capture src="images/06-finops-analysis/06-02-allocation-unit-economics.png" alt="Báo cáo tỷ lệ phân bổ và chi phí đơn vị với các chỉ số được quản trị" title="Tỷ lệ phân bổ và Unit Economics" capture="Chụp màn hình báo cáo thể hiện: chiều ownership, tổng chi phí cần phân bổ, chi phí đã/chưa phân bổ, tỷ lệ phân bổ (coverage %), chỉ số kinh doanh, kỳ báo cáo và chi phí đơn vị. Lưu ý: Kỳ chốt số liệu tài chính và kỳ chốt số liệu kinh doanh phải khớp nhau." caption="Hình ảnh minh họa cho báo cáo phân bổ; tuy nhiên, các tài liệu định nghĩa quy tắc phân bổ và chỉ số kinh doanh mới là nguồn tham chiếu chuẩn nhất." >}}

## Tiến độ hiện tại của dự án

Các quy tắc phân bổ và định nghĩa chỉ số Unit Economics đã được lập tài liệu. Tuy nhiên, cấu trúc ownership thực tế, tổng chi phí cần phân bổ, tỷ lệ phân bổ thực tế và nguồn dữ liệu kinh doanh vẫn chưa được tích hợp vào. Do đó, các chỉ số Unit Economics vẫn đang ở trạng thái chờ cho đến khi có đủ dữ liệu tài chính và kinh doanh.

{{< finops title="Kết luận FinOps" >}}
Việc phân bổ giúp gắn liền chi phí với người chịu trách nhiệm. Còn Unit Economics giúp chứng minh chi phí mà họ đã tiêu tạo ra được giá trị kinh doanh gì.
{{< /finops >}}
