---
title: "Phân tích KPI và Đọc hiểu CUDOS Dashboard"
weight: 2
chapter: false
pre: "5.2 "
description: "Hướng dẫn cách đọc số liệu, phân tích các điểm bất thường và quy trách nhiệm dựa trên các chỉ số của CUDOS."
services:
  - CUDOS v5
  - FinOps
  - Amazon Quick Sight
---
{{< badge "CUDOS v5" >}}
{{< badge "FinOps" >}}
{{< badge "KPIs" >}}

## Bối cảnh của Số liệu (Context)

Một con số hiển thị trên CUDOS sẽ vô nghĩa nếu thiếu các thông tin đi kèm sau:

```text
Khoảng ngày và múi giờ
Chỉ số chi phí và tiền tệ
Bộ lọc account/Region/service
Lần làm mới SPICE gần nhất
Định nghĩa kỳ so sánh
```

Bối cảnh này được lưu cùng mọi phát hiện. Nếu không, hai view dashboard có thể hiển thị các tổng khác nhau trong khi cả hai đều có vẻ đúng.

## Quy trình Phân tích Top-Down

CUDOS được thiết kế để bạn phân tích chi phí theo mô hình từ trên xuống dưới (Top-Down):

```text
Chi phí trong kỳ đã chọn
→ biến động so với kỳ trước
→ mức đóng góp của dịch vụ
→ account và Region
→ usage type hoặc resource
→ owner và ngữ cảnh workload
```

View tổng quan (Executive) cho bạn biết tổng tiền và xu hướng. View Service/Account cho bạn biết team nào, dịch vụ nào đang tiêu nhiều nhất. View Resource sẽ lôi mặt điểm tên chính xác ID của con server hay cái ổ cứng nào đang ngốn tiền.

## Các câu hỏi kinh doanh mà CUDOS giải quyết

| Cấp độ phân tích | Câu hỏi của dự án |
|---|---|
| Điều hành | Phạm vi đã chọn tốn bao nhiêu và đã thay đổi như thế nào? |
| Dịch vụ | Năm dịch vụ nào đóng góp nhiều nhất? |
| Account/Region | Biến động tập trung ở đâu? |
| Miền kỹ thuật | Compute, database, storage, AI/ML hay data transfer chịu trách nhiệm? |
| Tài nguyên/loại sử dụng | Tác nhân có thể quan sát nào mà owner nên điều tra? |
| Cam kết | Discount, RI hay Savings Plans có ảnh hưởng đến so sánh không? |

## Mẫu Ghi nhận Điểm bất thường (FinOps Finding)

```text
ID phát hiện (Finding ID):
Kỳ và múi giờ:
Chỉ số chi phí và tiền tệ:
Giá trị hiện tại:
Giá trị so sánh:
Độ thay đổi tuyệt đối / phần trăm:
Tác nhân chính theo service/account/Region/usage/resource:
Bằng chứng quan sát được:
Nguyên nhân có thể có (chưa xác nhận):
Chủ sở hữu:
Hành động xác minh tiếp theo:
Độ tin cậy: LOW / MEDIUM / HIGH
Trạng thái đối soát:
```

Xin lưu ý sự khác biệt giữa 'Hiện tượng' và 'Nguyên nhân': "Chi phí EC2 ở môi trường Staging tăng vọt" là một Hiện tượng thấy rõ trên biểu đồ. Còn "Do team Dev deploy nhầm mã nguồn gây vòng lặp vô hạn" là Nguyên nhân, và nó chỉ là giả thuyết cho đến khi bạn nói chuyện trực tiếp với Resource Owner.

## Đối soát Dữ liệu (Reconciliation)

Khi bạn thấy một số liệu bất thường trên CUDOS, bạn phải viết SQL chạy trên Athena (như hướng dẫn ở Chương 4) để đối chiếu lại. Nếu:

```text
MATCH
→ Chúc mừng, số liệu chính xác, có thể mang đi report.

EXPLAINED DIFFERENCE
→ Khác nhau nhưng giải thích được (VD: do chênh lệch múi giờ, do làm tròn số). Ghi chú lại lý do.

INVESTIGATE
→ Hai số lệch nhau quá nhiều và không thể giải thích. KHÔNG ĐƯỢC báo cáo con số này cho đến khi tìm ra nguyên nhân.
```

Những nguyên nhân gây lệch số phổ biến nhất: Dữ liệu SPICE cũ chưa cập nhật, tháng hiện tại chưa chốt sổ (incomplete month), đang áp dụng/chưa áp dụng Credits/Refunds, hoặc do bạn đang so sánh Unblended Cost với Amortized Cost.

## Ghi nhận bằng chứng

Để ghi nhận một sự kiện FinOps, bạn chỉ cần một ảnh chụp màn hình Dashboard bao gồm đủ thông tin: filter thời gian, chỉ số quan trọng, và biểu đồ thể hiện sự thay đổi. Tránh việc chụp lắt nhắt từng thao tác click chuột vô nghĩa.

{{< capture src="images/05-cudos/05-01-cudos-dashboard-demo-synthetic.png" alt="Góc nhìn KPI CUDOS-style với phạm vi, tác nhân chi phí chính và đối soát nguồn tổng hợp" title="Minh họa KPI và đối soát CUDOS-style" capture="Dùng lại ảnh dashboard CUDOS Dashboard Demo [Synthetic] đã publish ở mục 5.1. Ảnh phải thể hiện tháng 7/2026, tổng chi phí $1.180,00, AmazonEC2 là tác nhân $693,30 và Region Sydney, cùng một text note hiển thị rõ nguồn Direct Query là dữ liệu tổng hợp." caption="Kết quả dashboard đối soát với nguồn Athena tổng hợp dùng chung. Nó minh họa phương pháp rà soát, không phải tuyên bố đối soát cho các dataset SPICE CUDOS thực." >}}

{{< finops title="Kết luận FinOps" >}}
CUDOS tạo ra giá trị khi rút ngắn đường đi từ một biến động tài chính đã đối soát đến owner và bằng chứng kỹ thuật cần thiết cho quyết định.
{{< /finops >}}
