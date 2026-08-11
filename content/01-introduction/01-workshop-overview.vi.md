---
title: "Bối cảnh, mục tiêu và tiêu chí thành công"
weight: 1
chapter: false
pre: "1.1 "
description: "Xác định hiện trạng, mục tiêu dự án, phạm vi, tiêu chí nghiệm thu và yêu cầu về bằng chứng."
duration: "10 phút"
services:
  - AWS Billing
  - AWS Data Exports
  - Amazon Athena
  - Amazon Quick Sight
  - Amazon Quick
---
{{< badge "AWS Billing" >}}
{{< badge "FinOps" >}}
{{< badge "Amazon Quick" >}}


## Hiện trạng doanh nghiệp

Thông thường, các tổ chức sẽ vận hành nhiều loại workload khác nhau (production, staging, và shared services) trên AWS. Dữ liệu chi phí luôn có sẵn trong hệ thống billing của AWS, nhưng rắc rối ở chỗ: đội ngũ Tài chính, đội Quản trị nền tảng và đội Kỹ thuật ứng dụng lại không có chung một ngôn ngữ và quy chuẩn để phân tích chi phí.

Điều này dẫn đến những bất cập phổ biến như:

- Đội Tài chính thấy tổng chi phí hàng tháng nhưng không thể biết hệ thống hay team nào xài lố;
- Đội Kỹ thuật nắm được mức độ sử dụng (usage) nhưng không biết nó tốn bao nhiêu tiền;
- Cùng một Dashboard nhưng mỗi người lại dùng một bộ filter hay khung thời gian khác nhau để so sánh;
- Có nhiều ý tưởng tối ưu được đưa ra nhưng không ai chịu trách nhiệm thực thi hay đo lường;
- Trợ lý AI có thể giải thích chi phí rất bùi tai, nhưng lại dựa trên dữ liệu cũ không còn chính xác.

## Những câu hỏi dự án phải trả lời

- Chúng ta đang chi bao nhiêu?
- Dịch vụ và tài khoản nào tạo ra phần chi tiêu lớn nhất?
- Chi tiêu thay đổi theo thời gian như thế nào?
- Những workload nào có thể phân bổ cho đội, sản phẩm hoặc cost center?
- Đỉnh chi phí nào cần được điều tra?
- Có thể tăng tốc an toàn các hoạt động điều tra lặp lại hay không?

## Mục tiêu dự án

Mục tiêu cốt lõi không chỉ là vẽ biểu đồ chi phí AWS. Dự án hướng tới việc xây dựng một hệ thống hỗ trợ ra quyết định minh bạch và có thể truy vết:

```text
Dữ liệu hóa đơn gốc (Billing)
→ Các chỉ số (metric) chuẩn hóa
→ Dashboard hiển thị dữ liệu đã đối soát
→ Gán quyền sở hữu (ownership) cho các điểm bất thường
→ Có phương án xử lý & người chịu trách nhiệm
→ Đo lường kết quả tiết kiệm thực tế
```

Các thành phần AI chỉ là phần mở rộng tùy chọn. Chúng chỉ hữu ích sau khi đường dẫn xác định đã hoạt động.

## Tiêu chí thành công

| Lĩnh vực | Tiêu chí nghiệm thu |
|---|---|
| Nền tảng dữ liệu | Dữ liệu CUR 2.0 được lưu trên S3 dưới định dạng Parquet và được crawl thành bảng (catalog) đầy đủ. |
| Tính chuẩn hóa | Athena có thể truy vấn và ra kết quả khớp hoàn toàn với một metric trên CUDOS (cùng khung thời gian & điều kiện lọc). |
| Hỗ trợ quyết định | Có ít nhất một biến động chi phí lớn được điều tra và quy trách nhiệm rõ ràng cho đội ngũ kỹ thuật liên quan. |
| Tối ưu hóa | Phân biệt rõ giữa "Khoản tiết kiệm dự tính (trên giấy)" và "Khoản tiết kiệm thực tế đo lường được". |
| Phân bổ (Allocation) | Tỷ lệ phân bổ chi phí được đo lường dựa trên định nghĩa rõ ràng về "những loại chi phí nào cần phân bổ". |
| Unit Economics | Chỉ số kinh doanh (mẫu số) phải có nguồn cấp dữ liệu rõ ràng, có người phụ trách và chu kỳ đo lường chuẩn. |
| Vận hành | Khi có bất thường về chi phí, hệ thống phải gửi cảnh báo đúng người và nhận được phản hồi cụ thể. |
| Quản trị | Hệ thống phân tích (BI/AI) chỉ có quyền Read-only, tuyệt đối không có quyền can thiệp hay thay đổi hệ thống thực tế. |
| Vòng đời tài nguyên | Các tài nguyên tạo ra trong dự án phải có vòng đời rõ ràng: hoặc bị xóa đi, hoặc được giữ lại có chủ đích kèm người phụ trách. |

## Phạm vi dự án

Hệ thống cốt lõi sẽ tập trung vào CUR, Athena, CUDOS, QuickSight và mô hình vận hành FinOps. Phần Chat Agent và Flows của Amazon Q chỉ là tùy chọn mở rộng (vì phụ thuộc vào độ sẵn sàng, license và chính sách bảo mật của từng công ty). Việc thiếu đi Amazon Q không làm giảm đi giá trị cốt lõi của hệ thống FinOps này.

## Yêu cầu về bằng chứng nghiệm thu (Evidence Model)

Dự án này yêu cầu bằng chứng chứng minh **kết quả thực tế**, chứ không phải chụp lại từng cú click chuột trên màn hình. Chúng tôi sẽ sử dụng các bằng chứng ngắn gọn sau:

| Mục tiêu nghiệm thu | Bằng chứng cần lưu | Mục đích |
|---|---|---|
| CUR delivery | Có ít nhất một file Parquet trong thư mục phân vùng của tháng hiện tại trên S3. | Chứng minh dữ liệu billing đã chảy về kho lưu trữ thành công. |
| Athena validation | Lưu lại câu lệnh SQL, kết quả query, DB/Table sử dụng, khung thời gian và metric đối soát. | Đảm bảo tính minh bạch và có thể query lại bất kỳ lúc nào. |
| CUDOS readiness | Quá trình SPICE ingestion thành công kèm theo một view dashboard đã được filter. | Chứng minh nền tảng BI đã sẵn sàng phục vụ. |
| Đối soát tài chính | So khớp tổng chi phí giữa Athena và CUDOS trên cùng một điều kiện thời gian & metric. | Phát hiện các sai lệch do lỗi refresh data hoặc sai điều kiện lọc. |
| FinOps finding | Ghi nhận chi phí nền (baseline), nguyên nhân, người chịu trách nhiệm, hành động đề xuất và cách đo lường. | Biến việc "nhìn số" thành hành động thực tế có người chịu trách nhiệm. |
| Phân bổ & Unit Economics | Cung cấp công thức tính % coverage hoặc mẫu số kinh doanh kèm theo nguồn cấp dữ liệu. | Gắn liền chi phí cloud với từng team hoặc một giá trị kinh doanh cụ thể. |
| Alerting | Cấu hình Monitor/Subscription thành công và log hiển thị tin nhắn cảnh báo đã được gửi đi. | Đảm bảo hệ thống phát hiện bất thường đang hoạt động. |
| Cleanup | Danh sách (Inventory) các tài nguyên đã bị xóa và tài nguyên cố ý giữ lại. | Đảm bảo dự án FinOps không trở thành một mớ tài nguyên gây lãng phí tiền bạc. |

Lưu ý: Chỉ dùng ảnh chụp màn hình (screenshot) khi nó thực sự thể hiện được các kết quả trên. Nếu có thể, hãy ưu tiên lưu lại câu lệnh SQL, đoạn log, hoặc bảng kết quả nhỏ thay vì những bức ảnh khó kiểm chứng.

## Nguyên tắc thiết kế

### Có bằng chứng trước, Dùng AI sau

```text
Dữ liệu gốc (Billing) → Định nghĩa Metric → Đối soát (Validation) → Nhờ AI giải thích
```

### Hiểu rõ hệ thống trước khi Tối ưu (Observability before Optimization)

Trước khi đề xuất cắt giảm bất cứ thứ gì, bạn phải trả lời được: **cái gì vừa tăng chi phí, tăng ở đâu và ai đang quản lý nó?**

### Phê duyệt trước khi Can thiệp

Dự án này tuyệt đối không cấp cho AI hay bất kỳ tool tự động nào quyền hạn để tự ý terminate EC2 instance, xóa database, đổi quyền IAM hay mua các gói cam kết (commitment) mà không có sự đồng ý của con người.

{{< validation >}}
Phạm vi dự án nhất quán khi mọi chi phí được báo cáo đều có thể truy về metric, kỳ, tập filter, trạng thái refresh và nguồn có thẩm quyền.
{{< /validation >}}

{{< finops title="Điểm rút ra về FinOps" >}}
FinOps không đơn thuần là cắt giảm chi phí. FinOps tạo ra trách nhiệm tài chính chung giữa kỹ thuật, tài chính, sản phẩm và lãnh đạo.
{{< /finops >}}
