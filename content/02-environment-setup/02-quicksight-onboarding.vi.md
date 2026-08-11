---
title: "Thiết lập QuickSight, Identity và Quản lý dung lượng"
weight: 2
chapter: false
pre: "2.2 "
description: "Xác định cách QuickSight được cấp phát, định cỡ và phân quyền sở hữu cho CUDOS, thay vì chỉ coi việc này là vài cú click chuột."
services:
  - Amazon Quick
  - Amazon Quick Sight
  - SPICE
---
{{< badge "Amazon Quick" >}}
{{< badge "Amazon Quick Sight" >}}
{{< badge "SPICE" >}}

## Vai trò của QuickSight trong kiến trúc

QuickSight đóng vai trò là giao diện trình bày BI và xử lý truy vấn in-memory (qua SPICE) cho hệ thống CUDOS. Nó không thay thế kho dữ liệu của CUR hay Athena, mà chuyên lo việc quản lý Dataset, SPICE ingestion, áp dụng Filter và hiển thị các Dashboard tài chính đã được kiểm duyệt.

Tính năng trợ lý ảo Amazon Q được coi là một lớp mở rộng tùy chọn. Dù không có Amazon Q (hoặc các tính năng Q Flows), các Dashboard cốt lõi của CUDOS vẫn phải hoạt động bình thường độc lập.

## Phân định quyền sở hữu (Ownership)

Trước khi triển khai CUDOS, dự án cần chốt 4 thông tin cơ bản về thiết lập QuickSight:

| Quyết định | Giá trị đối với dự án |
|---|---|
| Region của QuickSight Account | Thường là `ap-southeast-2` (tương tự như AWS Account) |
| Mô hình xác thực | Theo tài khoản; hoặc tích hợp qua IAM Identity Center |
| Chủ sở hữu (Owner) của Asset | Chỉ định cụ thể người dùng (User) hoặc Nhóm (Group) |
| Admin quản lý dịch vụ | Người chịu trách nhiệm cấp phát dung lượng SPICE, chia sẻ quyền truy cập và xóa tài nguyên |

Trong môi trường Production thực tế, việc chọn mô hình xác thực (VD: tích hợp IAM Identity Center) rất quan trọng, vì nó quyết định cách bạn phân quyền cho các phòng ban và cách thu hồi quyền (offboarding) khi nhân sự nghỉ việc.

## Điều kiện sẵn sàng (Readiness Checklist)

Dịch vụ QuickSight được coi là sẵn sàng để deploy CUDOS khi thỏa mãn tất cả các điều kiện sau:

- QuickSight Account đã được khởi tạo đúng Region dự kiến;
- Chủ sở hữu (Owner) có thể truy cập thành công vào Dataset, Analysis và Dashboard;
- Dung lượng SPICE hiện tại đủ lớn để chứa lượng dữ liệu dự kiến của CUDOS;
- Service Role của QuickSight có đủ quyền đọc dữ liệu từ Athena, Glue và S3;
- Tính năng chia sẻ Dashboard mặc định KHÔNG được để ở chế độ Public.

Nếu thiếu bất kỳ yếu tố nào, việc triển khai CUDOS có nguy cơ thất bại hoặc Dashboard sẽ không thể làm mới (refresh) dữ liệu. Do đó, hãy đảm bảo check kỹ các mục này trước khi chạy lệnh `cid-cmd`.

## Quản lý Chi phí và Dung lượng (SPICE Capacity)

SPICE và các tính năng nâng cao của Amazon Q sẽ tiêu tốn một khoản chi phí duy trì hàng tháng. Bạn chỉ nên mua thêm dung lượng SPICE khi có lỗi thiếu dung lượng (ingestion error) thực tế xảy ra, hoặc khi đã đo đạc chính xác kích thước Dataset. Đừng mua thừa thãi ngay từ đầu chỉ để "cho chắc".

```text
Tài khoản/Region của QuickSight:
Chủ sở hữu các resource:
Mô hình xác thực:
Dung lượng SPICE hiện tại:
Kích thước dự kiến của các Dataset CUDOS:
Thiết lập chia sẻ mặc định:
Trạng thái sẵn sàng: READY / BLOCKED
```

{{< validation >}}
QuickSight chỉ được coi là sẵn sàng nếu quyền sở hữu, Region, dung lượng SPICE, phân quyền đọc dữ liệu và chính sách chia sẻ mặc định đều đã được rà soát và cấu hình chuẩn.
{{< /validation >}}
