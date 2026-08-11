# AWS FinOps Intelligence với CUDOS v5

Dự án triển khai AWS FinOps dựa trên bằng chứng (evidence-backed), kết nối dữ liệu cước phí CUR 2.0 để đối soát qua Athena, trực quan hóa trên Dashboard CUDOS v5, phân bổ và tối ưu hóa chi phí có trách nhiệm, cảnh báo bất thường, và tích hợp các luồng Amazon Q tùy chọn.

Toàn bộ tài liệu hướng dẫn của dự án này đã được **Việt hóa hoàn toàn** với văn phong kỹ thuật (Tech-savvy/Cloud Architect) giúp các team tại Việt Nam dễ dàng tiếp cận và triển khai quy trình Quản trị chi phí (FinOps) trên AWS.

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

- **Đã xác thực:** Phân phối file Parquet CUR 2.0, hiện diện trong Glue catalog, cấu trúc/truy vấn Athena, và thống kê quét (scan) truy vấn.
- **Đã định nghĩa nhưng chờ chạy thực tế:** Mức độ sẵn sàng CUDOS/SPICE, ghi nhận lỗi FinOps đã đối soát, độ bao phủ phân bổ, kiểm tra truyền tải cảnh báo, và nhật ký dọn dẹp.
- **Phần mở rộng tùy chọn:** Chatbot Amazon Q và Q Flows điều tra có quản trị.

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

## Cấu trúc Repository

- `content/` — Các chương tài liệu dự án (đã được Việt hóa)
- `static/images/` — Hình ảnh minh họa dự án
- `layouts/shortcodes/` — Các thành phần tái sử dụng (callout/cảnh báo)
- `docs/` — Ghi chú planning của dự án
- `.github/workflows/hugo-pages.yml` — Build và deploy lên GitHub Pages

## Nguyên tắc Xuất bản

Trước khi publish hình ảnh/ảnh chụp màn hình, hãy kiểm tra lại Account ID, ARN, tên bucket, địa chỉ email, mã định danh tổ chức và các giá trị tài chính thực tế. Account ID không phải là password, nhưng KHÔNG NÊN vô tình để lộ ra ngoài. Hãy đảm bảo bạn đã che (redact) các thông tin nhạy cảm.
