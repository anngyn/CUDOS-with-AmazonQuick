---
title: "Triển khai CUDOS v5 và Tiêu chí nghiệm thu"
weight: 1
chapter: false
pre: "5.1 "
description: "Hướng dẫn cách triển khai CUDOS Dashboard, thống kê các tài nguyên được tạo và các tiêu chí cần đạt để nghiệm thu."
services:
  - CUDOS v5
  - cid-cmd
  - Amazon Quick Sight
  - SPICE
---
{{< badge "CUDOS v5" >}}
{{< badge "cid-cmd" >}}
{{< badge "Amazon Quick Sight" >}}

Tài liệu tham khảo chính thức:

`https://docs.aws.amazon.com/guidance/latest/cloud-intelligence-dashboards/deployment-in-global-regions.html`

## Vai trò của CUDOS

CUDOS là một Dashboard phân tích được xây dựng bên trên CUR và Athena. Nó trực quan hóa các con số khô khan thành các biểu đồ dễ hiểu cho Ban Giám đốc, Quản lý dự án, hoặc kỹ sư. Tuy nhiên, CUDOS không tự sinh ra dữ liệu; độ tin cậy của CUDOS phụ thuộc hoàn toàn vào hệ thống dữ liệu gốc mà chúng ta đã setup và đối soát ở Chương 3, Chương 4.

## Cấu hình Triển khai

Dự án này sử dụng công cụ `cid-cmd` chạy trên AWS CloudShell để cài đặt tự động, thay vì phải tự tay tạo từng biểu đồ. Các thông số môi trường được chốt như sau:

| Thiết lập | Giá trị của dự án |
|---|---|
| Region trên AWS Console | Asia Pacific (Sydney) |
| Mã AWS Region | `ap-southeast-2` |
| Múi giờ làm mới dataset | `Australia/Sydney` |
| Database/table CUR | `cid_data_export.cur2` |
| Athena workgroup | `primary` |

Lưu ý: Bạn nên ghi lại phiên bản của công cụ `cid-cmd` vì các câu hỏi cài đặt (prompt) có thể thay đổi trong tương lai.

## Các bước Cài đặt trên CloudShell

Đây là đường dẫn vận hành được dùng cho dự án. Không cần chụp từng prompt trong terminal; tài sản cuối cùng và trạng thái ingestion là bằng chứng mạnh hơn.

### 1. Mở CloudShell tại Sydney và xác minh danh tính

Chọn **Asia Pacific (Sydney)** trên AWS Console, mở CloudShell và chạy:

```bash
aws sts get-caller-identity
aws configure get region
```

Hãy kiểm tra xem bạn có đang ở đúng AWS Account không. Nhớ che (redact) Account ID khi chụp ảnh màn hình. Nếu lệnh `aws configure get region` không ra kết quả thì cũng đừng lo, ta sẽ chỉ định cụ thể Region lúc chạy lệnh cài đặt.

{{< security >}}
CloudShell sử dụng phiên AWS Console hiện tại. Không chạy `aws configure` hoặc lưu access key dài hạn trong terminal.
{{< /security >}}

### 2. Cài đặt và kiểm tra `cid-cmd`

```bash
python3 -m ensurepip --upgrade
pip3 install --upgrade cid-cmd
cid-cmd --help
```

Mục đích của bước này là đảm bảo bạn cài đặt thành công `cid-cmd` và gọi được lệnh `cid-cmd --help`.

### 3. Kiểm tra vị trí kết quả Athena

CUDOS sẽ dùng Athena Workgroup mặc định (tên là `primary`) để chạy các câu SQL. Hãy kiểm tra xem Workgroup này sẽ lưu kết quả ở đâu:

```bash
aws athena get-work-group \
  --work-group primary \
  --region ap-southeast-2 \
  --query "WorkGroup.Configuration.ResultConfiguration.OutputLocation" \
  --output text
```

Kết quả dự kiến là một bucket tại Sydney dành riêng cho kết quả truy vấn Athena:

```text
s3://finops-workshop-athena-results-<ACCOUNT_ID>-ap-southeast-2/
```

TUYỆT ĐỐI KHÔNG lưu chung kết quả query vào Bucket chứa dữ liệu CUR 2.0 gốc. Việc trộn lẫn dữ liệu nguồn và dữ liệu query sẽ làm rối loạn hệ thống sau này.

### 4. Bắt đầu triển khai CUDOS v5

```bash
cid-cmd \
  --region_name ap-southeast-2 \
  deploy \
  --dashboard-id cudos-v5
```

Việc thêm tham số `--region_name` giúp đảm bảo mọi tài nguyên sẽ được tạo chính xác tại Sydney, tránh bị lệch Region.

### 5. Áp dụng các lựa chọn wizard của dự án

Công cụ sẽ hỏi bạn một loạt các cấu hình. Hãy trả lời theo bảng dưới đây (thứ tự câu hỏi có thể thay đổi tùy version):

| Quyết định trong wizard | Lựa chọn của dự án | Nguyên nhân |
|---|---|---|
| Athena database | `cid_data_export` | Chứa table CUR 2.0 `cur2` |
| Athena workgroup | `primary` | Dùng cấu hình kết quả truy vấn đã kiểm chứng |
| Athena result bucket | `finops-workshop-athena-results-<ACCOUNT_ID>-ap-southeast-2` | Tách kết quả truy vấn khỏi dữ liệu nguồn CUR |
| Quick Sight data source | `CID-CMD-Athena <CREATE NEW DATASOURCE>` | Lần triển khai đầu; dùng lại `CID-CMD-Athena` nếu đã tồn tại ở Sydney |
| Quick Sight data-source role | `CidCmdQuickSightDataSourceRole <ADD NEW ROLE>` | Lần triển khai đầu; dùng lại role do CID quản lý nếu đã tồn tại |
| Cost allocation tags | Để trống, sau đó chọn `Looks good` | Account chưa có taxonomy kinh doanh được phê duyệt |
| Múi giờ làm mới dataset | `Australia/Sydney` | Đồng bộ lịch làm mới với địa điểm triển khai |
| Trường taxonomy của dashboard | Để trống, sau đó chọn `Looks good` | Các trường parent của một account không bổ sung ngữ cảnh phân bổ hữu ích |

Nếu `cid-cmd` đề xuất cập nhật policy truy cập Athena cho role do CID quản lý, hãy kiểm tra phạm vi tài nguyên trước khi xác nhận. Không thêm tag có cardinality cao chỉ vì công cụ phát hiện được; chúng làm tăng kích thước dataset và mức sử dụng SPICE nhưng không cải thiện khả năng phân bổ.

Khi chạy xong, hệ thống sẽ tự sinh ra các View trên Athena (`summary_view`, `resource_view`, `hourly_view`...) và bản thân cái CUDOS Dashboard trên QuickSight. Vui lòng không đóng tab CloudShell khi lệnh chưa chạy xong.

## Chuỗi phụ thuộc

Quá trình cài đặt chỉ thực sự thành công khi thỏa mãn chuỗi điều kiện sau:

```text
CUR 2.0 đã bàn giao
→ Glue table trỏ đến prefix bàn giao
→ Truy vấn Athena thành công
→ Có owner Quick Sight và quyền truy cập nguồn
→ Có đủ capacity SPICE
→ cid-cmd tạo và làm mới asset CUDOS
```

Nếu cài đặt bị lỗi, đừng vội đổ tại CUDOS. Lỗi thường nằm ở các khâu trước đó: Dữ liệu CUR chưa về kịp, thiếu quyền IAM, hoặc QuickSight hết dung lượng SPICE.

## Mô hình tài sản được tạo

Phiên bản CUDOS v5 sử dụng 3 dataset chính là: `summary_view`, `resource_view` và `hourly_view`. Tuy nhiên, tên gọi chính xác có thể thay đổi chút ít theo từng bản cập nhật. Hãy ghi nhận lại tất cả các dataset được tạo ra cùng với phiên bản `cid-cmd`.

## Ghi nhận Trạng thái Cài đặt

```text
Phiên bản cid-cmd:
Dấu thời gian triển khai:
Region:
ID/phiên bản dashboard:
Database/table CUR:
Owner Quick Sight:
Dataset được tạo:
Trạng thái/thời điểm ingestion gần nhất:
Trạng thái lệnh cuối:
```

Lưu ý: Việc "mở được Dashboard lên xem" chưa chắc là dữ liệu đã mới. Bạn có thể đang xem một cái Dashboard có giao diện đẹp đẽ nhưng dữ liệu bên trong là của tháng trước do Refresh thất bại.

## Điều kiện Nghiệm thu

Dự án sẽ chỉ nghiệm thu bước cài đặt CUDOS khi đạt đủ 5 tiêu chí:

1. Lệnh triển khai trên CloudShell báo thành công 100%;
2. Các Dataset và Dashboard đã xuất hiện trên QuickSight;
3. Quá trình Refresh dữ liệu vào SPICE báo `Successful`;
4. Dashboard hiển thị được dữ liệu thực tế của kỳ hiện tại;
5. Ít nhất một chỉ số tổng (Total Cost) khớp chuẩn xác với kết quả query trên Athena.

{{< capture src="images/05-cudos/05-01-cudos-datasets-spice.png" alt="Danh sách dataset trên Amazon Quick hiển thị ba dataset CUDOS v5 trong SPICE" title="Danh mục dataset CUDOS v5" capture="Chụp Amazon Quick → Data với summary_view, resource_view và hourly_view cùng nhãn SPICE. Giữ tên tài sản và thông tin Last Modified; che account và định danh người dùng." caption="Danh mục tài sản chứng minh ba dataset CUDOS dự kiến đã tồn tại và sử dụng SPICE." >}}

{{< capture src="images/05-cudos/05-01-cudos-dashboard.png" alt="CUDOS Dashboard v5 đã triển khai và đang mở trên Amazon Quick" title="CUDOS Dashboard v5 hoạt động tại Sydney" capture="Mở CUDOS Dashboard v5 và chụp một góc nhìn sử dụng được, có tiêu đề, kỳ đã chọn và dữ liệu hiển thị hoặc giới hạn dữ liệu kỳ hiện tại được nêu rõ. Giữ ngữ cảnh Region Sydney nếu giao diện hiển thị; che chi tiết tài chính và danh tính không nên công khai." caption="Dashboard đang mở chứng minh tài sản phân tích có thể truy cập; không cần thêm ảnh danh sách dashboard." >}}

{{< capture src="images/05-cudos/05-02-cudos-spice-ingestion.png" alt="Trạng thái ingestion SPICE của dataset CUDOS v5 summary_view" title="Lần ingestion CUDOS SPICE gần nhất" capture="Mở lịch sử ingestion hoặc refresh của summary_view và chụp trạng thái Successful hoặc Completed gần nhất cùng timestamp. Giữ tên dataset và ngữ cảnh SPICE; che các định danh nội bộ." caption="Chỉ trạng thái Successful hoặc Completed kèm timestamp mới vượt qua cổng độ mới dữ liệu. Ảnh In progress chỉ ghi nhận refresh đang chờ và phải được chụp lại sau khi hoàn tất." >}}

{{< note >}}
Một export CUR 2.0 mới có thể chỉ chứa kỳ thanh toán hiện tại. Khi đó, các visual Previous Month, Two Months Ago hoặc Three Months Ago có thể hiển thị `No data` dù CUDOS đã được triển khai đúng. Nguyên nhân là chưa đủ lịch sử billing, không mặc nhiên là dashboard bị lỗi.
{{< /note >}}

## Dashboard CUDOS-style minh họa

CUDOS Dashboard v5 đã triển khai vẫn là asset dùng để chứng minh quá trình deploy. Khi lịch sử CUR thực chưa đủ để dashboard trình bày hữu ích, dự án có thêm dashboard độc lập **CUDOS Dashboard Demo [Synthetic]**. Dashboard này dùng Amazon Quick Direct Query tới `finops_demo.cudos_dashboard_demo_mock`, không dùng SPICE và dùng chung nguồn chi phí tổng hợp với phần 6.1 và 6.2.

Các con số được đối soát xuyên suốt dự án:

```text
Tổng chi phí tháng 7:       $1.180,00
Tác nhân AmazonEC2:           $693,30
Phần EC2 staging:             $135,30
Khoản giảm đo ở mục 6.1:       $15,00
Chi phí đã phân bổ ở mục 6.2:$1.142,80
Chi phí chưa phân bổ ở 6.2:    $37,20
```

{{< capture src="images/05-cudos/05-01-cudos-dashboard-demo-synthetic.png" alt="Dashboard Amazon Quick theo phong cách CUDOS, dùng nguồn chi phí tổng hợp có liên kết" title="Dashboard chi phí CUDOS-style minh họa" capture="Tạo dashboard Direct Query từ CUDOS Dashboard Demo [Synthetic]. Hiển thị kỳ tháng 7, tổng chi phí, xu hướng chi phí hằng ngày, chi phí theo service và chi phí theo owner. Giữ nhãn synthetic/demo trên dashboard." caption="Bộ dữ liệu minh họa: dashboard này trực quan hóa nguồn dữ liệu tổng hợp dùng chung cho chương 5 và 6. Nó không thay thế bằng chứng triển khai CUDOS v5 hoặc ingestion SPICE." >}}

## Trạng thái hiện tại của dự án

CUR, Glue và Athena đã có bằng chứng runtime trong repository này. Dự án cũng đã có dashboard Direct Query minh họa hoàn chỉnh dựa trên nguồn chi phí tổng hợp dùng chung. Tuy nhiên, cổng nghiệm thu CUDOS v5 vẫn cần biên bản triển khai, ingestion SPICE thành công và một chỉ số CUR thực đã đối soát; dashboard minh họa không tuyên bố thay thế các điều kiện đó.

{{< validation >}}
`Dashboard mở được` không phải điều kiện thành công cuối cùng. Trạng thái được chấp nhận là `dashboard mở được + dataset có dữ liệu mới + một metric cụ thể đối soát được với Athena`.
{{< /validation >}}
