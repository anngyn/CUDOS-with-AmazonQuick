---
title: "AWS FinOps Intelligence Workshop"
weight: 1
chapter: false
---

# AWS FinOps Intelligence Workshop

Chào mừng bạn đến với **AWS FinOps Intelligence Workshop**. Bài lab thực hành này sẽ hướng dẫn bạn xây dựng một nền tảng FinOps Intelligence toàn diện trên AWS sử dụng AWS Billing, CUR 2.0, Amazon Athena, CUDOS v5, Amazon QuickSight, Amazon Q và các workflow Agentic AI.

{{< architecture title="AWS FinOps Intelligence Architecture" src="/images/architecture.png" caption="Kiến trúc Data Pipeline FinOps Toàn Diện" >}}

```text
AWS Billing
└── AWS Data Exports / CUR 2.0
      └── Amazon S3
            └── AWS Glue & Amazon Athena
                  └── CUDOS v5 & Amazon QuickSight
                        └── Amazon Q & Agentic FinOps
```

## Các Module Trong Workshop

1. [01. Giới thiệu](01-introduction)
2. [02. Thiết lập môi trường](02-environment)
3. [03. Nền tảng CUR 2.0](03-cur2)
4. [04. Tích hợp Amazon Athena](04-athena)
5. [05. CUDOS v5 Dashboards](05-cudos)
6. [06. Phân tích chi phí FinOps](06-finops-analysis)
7. [07. Tùy chỉnh QuickSight](07-customize-quick-sight)
8. [08. Amazon Q & Generative AI FinOps](08-amazon-quick)
9. [09. Agentic FinOps Workflows](09-agentic-finops)
10. [10. Phát hiện bất thường chi phí](10-custom-anomaly)
11. [11. Bảo mật & Quản trị](11-security-governance)
12. [12. Dọn dẹp tài nguyên](12-cleanup)
