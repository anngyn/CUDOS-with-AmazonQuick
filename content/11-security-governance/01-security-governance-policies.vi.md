---
title: "Phân quyền và Mô hình Vận hành FinOps"
weight: 1
chapter: false
pre: "11.1 "
description: "Ai được quyền xem dữ liệu? Ai chịu trách nhiệm khi chi phí tăng? Cách thiết lập lịch review chi phí định kỳ."
services:
  - Amazon Quick
  - Amazon S3
  - FinOps Governance
---
{{< badge "Bảo mật" >}}
{{< badge "Mô hình vận hành" >}}
{{< badge "FinOps" >}}

## Tại sao cần Mô hình Quản trị?

CUDOS giúp nhìn thấy chi phí, nhưng giá trị chỉ xuất hiện khi quyền truy cập, trách nhiệm và nhịp review được xác định rõ: ai xem, ai kiểm chứng và ai có quyền thay đổi workload.

## Ma trận phân quyền: rà soát kỹ thuật trực tiếp

Bảng dưới đây là kết quả rà soát chỉ-đọc cấu hình và resource permission tại `ap-southeast-2` ngày 14/08/2026. Tên principal được chủ động không công bố.

| Tài sản | Quyền hoặc control quan sát được | Tín hiệu chia sẻ công khai đã rà soát | Kết quả |
|---|---|---|---|
| S3 Data Exports | `AES256`; bật đủ 4 control S3 Block Public Access | Bucket policy và ACL công khai bị chặn bởi các control này | PASS trong phạm vi rà soát |
| S3 Athena results | `AES256`; bật đủ 4 control S3 Block Public Access | Bucket policy và ACL công khai bị chặn bởi các control này | PASS trong phạm vi rà soát |
| Athena `primary` | Ép cấu hình workgroup; kết quả query dùng `SSE_S3` | Không thuộc phạm vi chia sẻ của QuickSight | PASS trong phạm vi rà soát |
| Năm QuickSight dashboard đã triển khai | Mỗi dashboard có 1 principal tường minh | Không phát hiện principal namespace-wide, anonymous hoặc public-like trong `DashboardPermissions` | PASS cho resource permission đã rà soát |
| Topic FinOps Q&A [Synthetic] | Có 1 principal tường minh | Không phát hiện principal namespace-wide, anonymous hoặc public-like trong `TopicPermissions` | PASS cho resource permission đã rà soát |

Kết quả này không chứng nhận toàn bộ setting chia sẻ cấp account, embedding, IAM hay control cấp tổ chức. Nó chỉ chứng minh các tín hiệu resource-level đã nêu tại thời điểm audit.

[Tải biên bản access-governance máy có thể đọc](/data/audits/11-01-access-governance-audit.json)

## Phân công Trách nhiệm (Ownership)

```text
Chủ sở hữu dữ liệu FinOps:
Chủ sở hữu sản phẩm dashboard:
Chủ sở hữu metric/ngữ nghĩa:
Chủ sở hữu rà soát tối ưu hóa:
Chủ sở hữu hành động workload:
Chủ sở hữu bảo mật:
```

Không gộp vai trò xem dashboard với vai trò thay đổi workload. Sự tách biệt này giữ cho khuyến nghị phân tích không trở thành thay đổi hạ tầng không được kiểm soát.

## Lịch Review Chi phí định kỳ

```text
Hàng ngày: Trực cảnh báo (Anomaly Alerts)
Hàng tuần: Review các khoản tăng bất thường và lên plan xử lý
Hàng tháng: Chốt sổ (Billing), tính độ phủ Allocation và kiểm tra Savings Plans/RI
Hàng quý: Rà soát lại quyền truy cập (Access control) và dọn dẹp tài nguyên rác
```

Nhịp rà soát gắn với các sản phẩm bằng chứng: hồ sơ bất thường, backlog phát hiện, báo cáo phân bổ, phép đo khoản tiết kiệm và ma trận quyền truy cập.

## Quy tắc vận hành

- Mọi claim tài chính phải nêu rõ kỳ báo cáo, metric, phạm vi lọc và thời điểm refresh.
- Mỗi đề xuất tối ưu hóa phải có chủ sở hữu và bước xác minh tính khả thi.
- Chi phí chưa phân bổ phải được đo lường, không bị loại khỏi báo cáo.
- Kết quả từ AI chỉ hỗ trợ điều tra; phê duyệt hành động vẫn do con người thực hiện.
- Chỉ bật public sharing khi có quyết định được rà soát và ghi nhận rõ ràng.
- Báo cáo tách biệt khoản tiết kiệm đề xuất với khoản tiết kiệm đã đo lường.
- Mỗi tài nguyên được giữ lại phải có chủ sở hữu và ngày review tiếp theo.

## Trạng thái hiện tại của dự án

Ranh giới kỹ thuật đã có bằng chứng từ live audit tại mục 11.1 và 11.2. Phần còn lại thuộc trách nhiệm nghiệp vụ: ghi nhận người sở hữu dữ liệu, dashboard, metric, workload và bảo mật; đặt ngày review tiếp theo; và lưu biên bản access review đã được phê duyệt. Các thông tin này không được suy đoán từ session AWS tạm thời.

{{< finops title="Điểm rút ra về FinOps" >}}
Quản trị FinOps biến khả năng quan sát chi phí thành quyết định có trách nhiệm, nhưng không trao cho nền tảng phân tích quyền thay đổi workload không cần thiết.
{{< /finops >}}
