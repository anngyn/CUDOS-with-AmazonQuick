# AWS FinOps Intelligence với CUDOS v5

Dự án triển khai AWS FinOps dựa trên bằng chứng (evidence-backed), kết nối dữ liệu cước phí CUR 2.0 để đối soát qua Athena, trực quan hóa trên Dashboard CUDOS v5, phân bổ và tối ưu hóa chi phí có trách nhiệm, cảnh báo bất thường, và tích hợp các luồng Amazon Q tùy chọn.

Tài liệu có cả tiếng Việt và English, ưu tiên cách trình bày của một dự án kỹ thuật: mỗi claim nêu rõ nguồn, phạm vi, chỉ số, trạng thái bằng chứng và giới hạn của nó.

## Xem bản public

GitHub Pages được build tự động từ nhánh `main`:

`https://anngyn.github.io/CUDOS-with-AmazonQuick/`

Trang public giữ nguyên template workshop hiện có, bổ sung trạng thái delivery rõ ràng và ảnh evidence đã loại bỏ identifiers nhạy cảm.

## Kiến trúc Hệ thống

```text
AWS Billing / Data Exports
          ↓
        CUR 2.0
          ↓
          S3
          ↓
   Glue Data Catalog
          ↓
        Athena
          ↓
       CUDOS v5
          ↓
      Quick Sight
          ↓
Amazon Q (tùy chọn)
```

## Mục tiêu Dự án

Dự án thiết lập một lộ trình ra quyết định có thể truy vết được. Một con số chi phí sẽ không được chấp nhận cho đến khi xác định rõ kỳ hạn, số liệu đo lường, các bộ lọc, và trạng thái làm mới (refresh) dữ liệu. Một đề xuất tối ưu hóa sẽ không được tính là khoản tiết kiệm cho đến khi một thay đổi đã được phê duyệt được đo lường dựa trên một baseline tương đương.

Vì vậy, triển khai bao gồm:

- Xác minh luồng truyền dữ liệu cước phí (billing delivery) và truy vấn dữ liệu gốc;
- Đối soát một metric Athena với CUDOS cho cùng một phạm vi dữ liệu;
- Xác định điểm thay đổi chi phí lớn (cost mover) và chủ sở hữu của nó;
- Ghi nhận giả thuyết tối ưu hóa mà không "phóng đại" khoản tiết kiệm;
- Định nghĩa độ phủ phân bổ (allocation coverage) hoặc mẫu số unit-economics;
- Cấu hình một tín hiệu vận hành thông qua Cost Anomaly Detection;
- Dọn dẹp hoặc chủ đích giữ lại từng tài nguyên dự án rõ ràng.

## Trạng thái Bàn giao

- **Đã xác thực:** CUR 2.0 Parquet, Glue/Athena, truy vấn cost-by-service thực tế, CUDOS v5, Amazon Quick datasets/dashboards, và ranh giới S3/Athena/IAM đã audit.
- **Đã chạy bằng dữ liệu tổng hợp có nhãn:** walkthrough CUDOS, optimization outcome, allocation/unit economics, Amazon Quick Q&A và Flow điều tra có quản trị. Những bằng chứng này không được trình bày như số hóa đơn CUR thật.
- **Đã triển khai một phần:** Cost Anomaly monitor và SNS routing foundation. Delivery test cần Slack/email endpoint được phê duyệt.
- **Lifecycle:** inventory hiện tại đánh dấu các resource là `RETAINED`; teardown chưa được cấp quyền.

## Chạy Local

Yêu cầu: Hugo Extended. Workflow Pages hiện tại sử dụng Hugo `0.150.0`.

```bash
hugo server -D
```

Truy cập `http://localhost:1313/CUDOS-with-AmazonQuick/`.

Kiểm tra build production-style mà không ghi ra folder `public/`:

```bash
hugo --renderToMemory --minify --baseURL "https://example.com/CUDOS-with-AmazonQuick/"
```

## Deploy GitHub Pages

Workflow [hugo-pages.yml](.github/workflows/hugo-pages.yml) build Hugo Extended và deploy artifact khi có commit trên `main` hoặc `master`. Workflow dùng `--cleanDestinationDir`, vì vậy thư mục `public/` local không phải nguồn triển khai và không cần commit như bằng chứng build.

## Cấu trúc Repository

- `content/` — Các chương tài liệu dự án (đã được Việt hóa)
- `static/images/` — Hình ảnh minh họa dự án
- `layouts/shortcodes/` — Các thành phần tái sử dụng (callout/cảnh báo)
- `docs/` — Ghi chú planning của dự án
- `.github/workflows/hugo-pages.yml` — Build và deploy lên GitHub Pages

## Nguyên tắc Xuất bản

Trước khi publish hình ảnh/ảnh chụp màn hình, hãy kiểm tra lại Account ID, ARN, tên bucket, địa chỉ email, mã định danh tổ chức và các giá trị tài chính thực tế. Account ID không phải là password, nhưng KHÔNG NÊN vô tình để lộ ra ngoài. Hãy đảm bảo bạn đã che (redact) các thông tin nhạy cảm.
