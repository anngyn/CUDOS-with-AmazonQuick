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

Có tool xịn (như CUDOS) để nhìn thấy chi phí là tốt, nhưng nếu không có quy định RÕ RÀNG về việc: "Ai là người xem?", "Ai là người sửa lỗi?", "Bao lâu thì họp review một lần?" thì cái Dashboard đó cũng chỉ để chưng cho đẹp chứ không ai dùng.

## Ma trận Phân quyền (Access Matrix)

| Tài sản | Principal đọc | Quản trị viên/chủ sở hữu | Chia sẻ công khai | Kết quả rà soát |
|---|---|---|---|---|
| Data Exports S3 |  |  | đã tắt | PASS/FAIL |
| Glue/Athena |  |  | không áp dụng | PASS/FAIL |
| CUDOS/Quick Sight |  |  | đã tắt | PASS/FAIL |
| Quick Space/agent |  |  | đã tắt | PASS/FAIL |

Lưu ý: Chỉ cấp quyền cho IAM Role hoặc Group, TUYỆT ĐỐI không cấp trực tiếp cho User, và không ghi nhận các session tạm thời vào ma trận này.

## Phân công Trách nhiệm (Ownership)

```text
Chủ sở hữu dữ liệu FinOps:
Chủ sở hữu sản phẩm dashboard:
Chủ sở hữu metric/ngữ nghĩa:
Chủ sở hữu rà soát tối ưu hóa:
Chủ sở hữu hành động workload:
Chủ sở hữu bảo mật:
```

Tuyệt đối KHÔNG gộp chung 'Người xem Dashboard' và 'Người sửa hệ thống' làm một. Nếu không, bộ phận soi chi phí sẽ tự ý vào tắt server của team Dev mà không cần hỏi ý kiến.

## Lịch Review Chi phí định kỳ

```text
Hàng ngày: Trực cảnh báo (Anomaly Alerts)
Hàng tuần: Review các khoản tăng bất thường và lên plan xử lý
Hàng tháng: Chốt sổ (Billing), tính độ phủ Allocation và kiểm tra Savings Plans/RI
Hàng quý: Rà soát lại quyền truy cập (Access control) và dọn dẹp tài nguyên rác
```

Nhịp rà soát gắn với các sản phẩm bằng chứng: hồ sơ bất thường, backlog phát hiện, báo cáo phân bổ, phép đo khoản tiết kiệm và ma trận quyền truy cập.

## Luật chơi chung

- Khi báo cáo số tiền, bắt buộc phải nói rõ: Báo cáo tháng mấy? Số đã chiết khấu chưa?
- Đề xuất giảm chi phí phải có người chịu trách nhiệm verify tính khả thi.
- Những chi phí chưa chia được cho team nào (Untagged/Unallocated) thì PHẢI BÊ RA ÁNH SÁNG, không được giấu đi.
- AI (Amazon Q) chỉ được phép GỢI Ý, con người mới là người CHỐT thực thi.
- KHÔNG MỞ Public Dashboard trừ khi có lệnh từ sếp.
- Tách bạch rõ ràng giữa "Tiền dự kiến tiết kiệm" và "Tiền ĐÃ tiết kiệm được".
- Đã chạy xong dự án, giữ lại cái gì thì phải ghi rõ AI LÀ NGƯỜI ÔM và khi nào review lại.

## Trạng thái hiện tại của dự án

Đã lên khung ma trận quyền và luật chơi. Các control S3, Athena và QuickSight datasource role đã được audit tại mục 11.2; vẫn chờ các team chốt principal sở hữu, ngày review và biên bản access review nghiệp vụ thực tế.

{{< finops title="Điểm rút ra về FinOps" >}}
Quản trị FinOps là nghệ thuật bắt mọi người nhìn vào ví tiền và tự thấy xót, chứ không phải trao quyền cho team tài chính đi tắt server của team kỹ thuật.
{{< /finops >}}
