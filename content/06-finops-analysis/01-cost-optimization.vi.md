---
title: "Tối ưu hóa chi phí: Từ biến động đến kết quả thực tế"
weight: 1
chapter: false
pre: "6.1 "
description: "Quy trình xử lý một biến động chi phí: từ việc đối soát, tìm người chịu trách nhiệm, phê duyệt cho đến đo lường kết quả thực tế."
services:
  - CUDOS v5
  - FinOps
  - Cost Optimization
---
{{< badge "FinOps" >}}
{{< badge "Cost Optimization" >}}
{{< badge "CUDOS v5" >}}

## Mô hình vận hành

Tối ưu hóa chi phí là một quy trình có quản trị, chứ không đơn thuần là nhặt bừa vài gợi ý từ dashboard:

{{< evidence src="images/06-finops-analysis/06-01-evidence-driven-finops-operating-loop.png" alt="Vòng vận hành FinOps dựa trên bằng chứng: phát hiện bất thường, xác thực, phân bổ trách nhiệm, quản trị, hành động và đo lường" caption="Đây là quy trình vận hành của dự án. Quy trình này tách biệt rõ ràng các bước: đề xuất, phê duyệt, thực thi và đo lường khoản tiết kiệm thực tế." >}}

```text
Phát hiện biến động
→ xác thực lại số liệu
→ xác định tài nguyên/dịch vụ gây ra biến động
→ gán cho người chịu trách nhiệm (owner)
→ đánh giá rủi ro nếu thay đổi
→ phê duyệt hoặc từ chối đề xuất
→ thực thi trên hệ thống thực
→ đo lường kết quả tiết kiệm
```

## Đánh giá mức độ ảnh hưởng

Khi so sánh chi phí của kỳ hiện tại với kỳ trước đó, chúng ta cần giữ nguyên các metric và phạm vi dữ liệu:

```text
Thay đổi tuyệt đối (Absolute change) = chi phí hiện tại - chi phí kỳ trước
Phần trăm thay đổi (Percentage change) = độ thay đổi tuyệt đối / chi phí kỳ trước × 100%
```

Khi chi phí kỳ trước bằng 0, phần trăm thay đổi sẽ không xác định (`N/A`), nhưng con số thay đổi tuyệt đối vẫn giữ nguyên giá trị. Việc xem xét cả hai chỉ số này rất quan trọng, vì một mức tăng phần trăm rất lớn trên một chi phí ban đầu quá nhỏ thường không đáng để tốn thời gian tối ưu.

## Truy vết và Phân bổ trách nhiệm (Accountability)

Các biến động chi phí đáng kể sẽ được phân rã thành các cấp độ chi tiết dựa trên các trường dữ liệu của CUR:

```text
Dịch vụ (Service)
→ Tài khoản (Account)
→ Khu vực (Region)
→ Loại sử dụng (Usage type)
→ Tài nguyên cụ thể (Resource)
→ Người chịu trách nhiệm (Workload owner)
```

Việc truy vết (accountability) này chỉ giúp chúng ta biết chi phí tăng/giảm ở đâu, chứ không giải thích được lý do tại sao. Những nguyên nhân thực tế như: có đợt deploy mới, lưu lượng truy cập tăng đột biến, phí phát sinh một lần, credits hết hạn, hoặc thay đổi gói cam kết (commitment)... đều phải do chính đội ngũ kỹ thuật hoặc người quản lý nghiệp vụ xác nhận.

## Hồ sơ đề xuất tối ưu

Các cơ hội tối ưu thường xuất phát từ việc phát hiện tài nguyên nhàn rỗi, tỷ lệ sử dụng On-Demand quá cao, các gói cam kết (commitment) chưa được tận dụng, lưu trữ kém hiệu quả, hoặc phí data transfer bất thường. Trước khi thực hiện bất kỳ hành động nào, mỗi đề xuất cần được ghi chép lại rõ ràng:

```text
ID phát hiện:
Hiện tượng quan sát được:
Dữ liệu đối soát:
Người phụ trách (Owner):
Nguyên nhân thực tế (đã xác nhận):
Các điểm cần kiểm tra thêm:
Hành động đề xuất:
Cách tính khoản tiết kiệm dự kiến:
Đánh giá rủi ro và phương án rollback:
Trạng thái phê duyệt: PROPOSED / APPROVED / REJECTED
```

Cần lưu ý: khoản tiết kiệm dự kiến chỉ là con số ước tính trên giấy, không phải là kết quả thực tế. Con số này cần được phân biệt rõ ràng cho đến khi được đo lường lại sau khi thực thi.

## Đo lường kết quả

Sau khi một hành động tối ưu được phê duyệt và thực thi, chúng ta sẽ so sánh chi phí của kỳ hiện tại với kỳ cơ sở (baseline). Nếu có thể, số liệu này cần được điều chỉnh để loại trừ các biến động do nhu cầu sử dụng thực tế (ví dụ: lượng user tăng đột biến làm tăng chi phí):

```text
Ngày thực hiện:
Kỳ cơ sở (Baseline) & Chi phí:
Kỳ đo lường & Chi phí:
Điều chỉnh theo nhu cầu sử dụng thực tế:
Tiết kiệm ước tính (trước hành động):
Tiết kiệm thực tế (sau hành động):
Các tác dụng phụ ngoài ý muốn:
Trạng thái: VALIDATED / INCONCLUSIVE / ROLLED BACK
```

Ví dụ về chuỗi nhân quả:

```text
Chi phí compute môi trường staging tăng
→ resource usage cho thấy các EC2 instance bị bỏ quên, vẫn chạy qua đêm
→ owner xác nhận môi trường staging không cần chạy ngoài giờ làm việc
→ giải pháp tự động tắt bật (schedule) được phê duyệt (kèm phương án rollback)
→ đo lường chi phí ở các ngày tiếp theo
→ chỉ phần chi phí thực sự giảm đi mới được ghi nhận là "khoản tiết kiệm thực tế"
```

{{< capture src="images/06-finops-analysis/06-01-optimization-outcome-mock.png" alt="Dashboard Amazon Quick minh họa việc so sánh chi phí kỳ baseline và kỳ đo lường của một kết quả tối ưu hóa FinOps" title="Kết quả tối ưu hóa minh họa" capture="Chụp dashboard Amazon Quick đã publish, thể hiện xu hướng chi phí hằng ngày của kỳ baseline và kỳ đo lường, khoản tiết kiệm theo dịch vụ và Region, trạng thái kết quả đã xác thực, cùng bảng đối chiếu chi phí trước và sau." caption="Bộ dữ liệu minh họa: dashboard sử dụng một Athena Direct Query view độc lập để trình bày quy trình đo lường. Baseline $42, chi phí kỳ đo lường $27 và khoản giảm $15 là số liệu kịch bản tổng hợp, không phải khoản tiết kiệm thực tế được ghi nhận từ CUR 2.0 của dự án." >}}

## Tiến độ hiện tại của dự án

Dự án hiện có một dashboard Amazon Quick minh họa đầy đủ mô hình đo lường: xu hướng chi phí kỳ baseline và kỳ đo lường, phân bổ theo dịch vụ và Region, trạng thái kết quả và khoản giảm chi phí tổng hợp. Dashboard truy vấn một Athena Direct Query view độc lập nên không sử dụng phần SPICE đang thiếu và không làm thay đổi các dataset CUDOS. Do dữ liệu CUR 2.0 hiện tại chưa đủ lịch sử để tạo hai kỳ so sánh tương đương, khoản giảm $15 trên dashboard vẫn là kết quả của case study tổng hợp, chưa phải khoản tiết kiệm thực tế trên hóa đơn AWS.

{{< finops title="Kết luận FinOps" >}}
Một đề xuất (recommendation) từ công cụ sẽ không được coi là kết quả FinOps nếu thiếu đi sự xác nhận trách nhiệm (ownership), phê duyệt, triển khai thực tế và số liệu đo lường sau khi thực hiện.
{{< /finops >}}
