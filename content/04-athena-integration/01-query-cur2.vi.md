---
title: "Kiểm tra Athena và Đối soát dữ liệu CUDOS"
weight: 1
chapter: false
pre: "4.1 "
description: "Sử dụng Athena như một công cụ độc lập để truy vấn và xác minh tính chính xác của dữ liệu trên CUDOS."
services:
  - Amazon Athena
  - CUR 2.0
---
{{< badge "Amazon Athena" >}}
{{< badge "SQL" >}}
{{< badge "CUR 2.0" >}}

## Vai trò của Athena trong việc đối soát

Athena đóng vai trò là engine tính toán độc lập của dự án. Bạn chỉ nên tin tưởng các con số trên CUDOS Dashboard KHI VÀ CHỈ KHI bạn có thể dùng Athena viết SQL query ra được kết quả y hệt (với cùng dữ liệu CUR, cùng mốc thời gian, cùng account và cùng điều kiện filter).

Việc tách bạch Data và Dashboard giúp chúng ta phát hiện nhanh 2 lỗi cực kỳ phổ biến:

```text
1. Viết SQL ra số liệu mới, nhưng Dashboard hiện số cũ 
→ Do bộ đệm SPICE của QuickSight chưa kịp refresh.

2. Cùng là dữ liệu mới, nhưng hai bên lệch số 
→ Do SQL và Dashboard đang định nghĩa "chi phí" theo hai cách khác nhau (VD: chưa chiết khấu vs. đã chiết khấu).
```

## Lấy tên Database và Table

Tên Database và Table trong Athena sẽ phụ thuộc vào môi trường bạn vừa triển khai, thường được gọi chung là `<CUR_DATABASE>` và `<CUR2_TABLE>`. Đừng hard-code tên table theo các tài liệu cũ.

```sql
SHOW TABLES IN <CUR_DATABASE>;
```

Trong ví dụ này, chúng tôi đang sử dụng database là `cid_data_export` và table là `cur2`.

{{< evidence src="images/03-cur2/04-01-athena-database.png" alt="Trình soạn thảo truy vấn Athena với database và table CUR được chọn" caption="Bối cảnh phân tích được quan sát: database và table CUR đã tạo có thể sử dụng trong Athena." >}}

{{< evidence src="images/03-cur2/04-02-athena-show-tables.png" alt="Kết quả Athena SHOW TABLES chứa table CUR 2.0" caption="Kết quả catalog được quan sát: có thể phát hiện table CUR 2.0 qua SQL." >}}

## Kiểm tra khả năng đọc dữ liệu và Schema

Hãy chạy thử một lệnh SELECT đơn giản để đảm bảo Athena có thể đọc được dữ liệu do Glue Catalog trỏ tới:

```sql
SELECT *
FROM <CUR_DATABASE>.<CUR2_TABLE>
LIMIT 10;
```

{{< evidence src="images/03-cur2/04-03-athena-first-rows.png" alt="Truy vấn mẫu Athena trả về các bản ghi CUR 2.0" caption="Kết quả được quan sát: Athena trả về các dòng CUR 2.0 thực; các định danh tài chính đã được che trong bằng chứng công bố." >}}

Đồng thời, bạn cũng nên kiểm tra cấu trúc bảng (schema) trước khi viết các câu SQL phức tạp:

```sql
DESCRIBE <CUR_DATABASE>.<CUR2_TABLE>;
```

Dữ liệu chuẩn sẽ chứa đầy đủ các cột về: kỳ hóa đơn, account sử dụng, service/product, mốc thời gian, Region, loại chi phí (line item), tiền phí, thông tin Reservation/Savings Plans, tags, và Cost Categories.

{{< evidence src="images/03-cur2/04-04-athena-describe-cur2.png" alt="Kết quả Athena DESCRIBE cho table CUR 2.0" caption="Lược đồ được quan sát: table cung cấp các trường billing, line item và cost cần thiết cho mô hình FinOps." >}}

## Truy vấn thử Chi phí theo Service

Dưới đây là câu SQL cơ bản nhất: Nhóm tổng chi phí chưa chiết khấu (unblended cost) theo từng Service:

```sql
SELECT
    line_item_product_code AS service,
    ROUND(SUM(line_item_unblended_cost), 2) AS unblended_cost
FROM <CUR_DATABASE>.<CUR2_TABLE>
GROUP BY 1
ORDER BY 2 DESC
LIMIT 20;
```

Lưu ý: Loại chi phí phải được định nghĩa rõ ràng. Nếu bạn thay `unblended_cost` bằng chi phí đã phân bổ (amortized cost) hoặc chi phí thực tế sau chiết khấu (net cost), con số sẽ khác đi hoàn toàn và cần được giải thích riêng.

{{< evidence src="images/03-cur2/04-05-athena-cost-by-service.png" alt="Truy vấn chi phí theo dịch vụ của Athena và kết quả" caption="Kết quả được quan sát: table CUR có thể được tổng hợp theo dịch vụ bằng một chỉ số chi phí được nêu tên rõ ràng." >}}

## Tối ưu hóa Chi phí truy vấn (Performance)

Mỗi khi chạy lệnh, Athena sẽ báo thời gian chạy (run time) và lượng dữ liệu bị quét (data scanned). Những con số này cho bạn biết câu SQL của mình có đang tối ưu hay không (có query đúng cột không, có tận dụng định dạng Parquet không, có filter theo ngày không).

{{< evidence src="images/03-cur2/04-06-athena-query-statistics.png" alt="Thống kê hoàn tất truy vấn Athena" caption="Thống kê truy vấn được quan sát là đường cơ sở để tối ưu hóa chi phí quét." >}}

{{< cost >}}
Athena tính tiền dựa trên lượng GB dữ liệu bạn quét (scan). Do đó, LUÔN LUÔN dùng Parquet, chỉ SELECT các cột cần thiết, phải có điều kiện filter thời gian (WHERE date = ...), và hạn chế tối đa việc dùng `SELECT *` khi không thực sự cần.
{{< /cost >}}

## Đối soát số liệu với CUDOS Dashboard

Sau khi bạn cài đặt xong CUDOS, hãy chạy lệnh SQL sau trên Athena để tính tổng chi phí theo tháng, rồi so sánh với Dashboard:

```sql
SELECT
    DATE_TRUNC('month', line_item_usage_start_date) AS usage_month,
    ROUND(SUM(line_item_unblended_cost), 2) AS unblended_cost
FROM <CUR_DATABASE>.<CUR2_TABLE>
WHERE line_item_usage_start_date >= TIMESTAMP '<START_YYYY-MM-DD 00:00:00>'
  AND line_item_usage_start_date <  TIMESTAMP '<END_EXCLUSIVE_YYYY-MM-DD 00:00:00>'
GROUP BY 1
ORDER BY 1;
```

```text
Kỳ và múi giờ:
Bộ lọc account/Region:
Chỉ số chi phí:
Giá trị Athena:
Giá trị CUDOS:
Độ lệch tuyệt đối = CUDOS - Athena:
Độ lệch % = độ lệch tuyệt đối / Athena × 100:
Lần bàn giao CUR gần nhất:
Lần làm mới SPICE gần nhất:
Trạng thái: MATCH / EXPLAINED DIFFERENCE / INVESTIGATE
```

Nếu hai bên lệch nhau, hãy khoan hoảng hốt. Bạn cần điều tra nguyên nhân dựa trên: độ trễ dữ liệu của SPICE (refresh delay), dữ liệu tháng chưa chốt (incomplete month), các khoản credits/refunds (bù trừ), filter account, loại tiền tệ, hoặc do định nghĩa sai về cột chi phí (như nhầm giữa unblended và amortized).

{{< validation >}}
Xác thực Athena hoàn tất khi dữ liệu có thể đọc được, các cột bắt buộc tồn tại, SQL đã lưu tạo ra một chỉ số có tên, và chỉ số đó có hợp đồng đối soát được lập tài liệu với CUDOS.
{{< /validation >}}
