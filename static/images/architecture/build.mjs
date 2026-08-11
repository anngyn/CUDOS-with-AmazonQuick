// AWS FinOps Intelligence with CUDOS v5.
// Generated with the drawio-ai layout engine; coordinates are intentionally absent.
import { writeFileSync } from "node:fs";
import { Diagram } from "file:///C:/Users/NGUYENAN/AppData/Roaming/npm/node_modules/drawio-ai-kit/src/builder.mjs";
import { box, frame, group, icon, phantom, renderTree } from "file:///C:/Users/NGUYENAN/AppData/Roaming/npm/node_modules/drawio-ai-kit/src/layout-engine.mjs";

const d = new Diagram("pipeline");

// Plain boxes are used only where the AWS catalog has no exact service stencil.
const neutral = (id, label, opts = {}) =>
  box(id, label, { w: 132, h: 68, fill: "#FFFFFF", stroke: "#5A6B7B", bold: true, ...opts });

// Main evidence and analytics flow.
const financial = frame("financial", "Financial evidence", {
  dir: "row", gap: 18, align: "center", fill: "#FFFFFF", stroke: "#1B365D;dashed=1", dashed: true,
}, [
  neutral("billing", "AWS Billing"),
  icon("exports", "cost_and_usage_report", "AWS Data Exports\n/ CUR 2.0"),
  icon("s3", "s3", "Amazon S3"),
]);

const analytics = frame("analytics", "Data & analytics", {
  dir: "row", gap: 24, align: "center", fill: "#FFFFFF", stroke: "#1B365D;dashed=1", dashed: true,
}, [
  icon("glue", "glue_data_catalog", "AWS Glue\nData Catalog"),
  icon("athena", "athena", "Amazon Athena"),
]);

const intelligence = frame("intelligence", "FinOps intelligence", {
  dir: "row", gap: 24, align: "center", fill: "#FFFFFF", stroke: "#1B365D;dashed=1", dashed: true,
}, [
  neutral("cudos", "CUDOS v5", { w: 118 }),
  icon("quicksight", "quicksight", "Amazon QuickSight"),
  neutral("spice", "SPICE", { w: 88, h: 58, bold: true }),
]);

const ai = frame("ai", "Optional AI extension", {
  dir: "col", gap: 18, align: "center", fill: "#FFFFFF", stroke: "#1B365D;dashed=1", dashed: true,
}, [
  // `quick_suite` is the exact current mxgraph.aws4 Amazon Quick / Quick Suite stencil.
  icon("quick", "quick_suite", "Amazon Quick"),
  neutral("agent", "FinOps Chat\nAgent", { w: 132, h: 62 }),
  neutral("flows", "Quick Flows", { w: 132, h: 62 }),
]);

const main = phantom("main", "", { dir: "row", gap: 28, align: "top", header: 0 }, [
  financial,
  analytics,
  intelligence,
  ai,
]);

const controls = frame("controls", "Security & data protection", {
  dir: "row", gap: 42, align: "center", fill: "#FFFFFF", stroke: "#5A6B7B;dashed=1", dashed: true,
}, [
  icon("iam", "identity_and_access_management", "AWS IAM"),
  icon("kms", "key_management_service", "AWS KMS"),
]);

const operations = frame("operations", "Operations & governance", {
  dir: "row", gap: 28, align: "center", fill: "#FFFFFF", stroke: "#1B365D;dashed=1", dashed: true,
}, [
  neutral("anomaly", "AWS Cost Anomaly\nDetection", { w: 160, h: 68 }),
  icon("sns", "sns", "Amazon SNS"),
  neutral("slack", "Approved Slack\nchannel", { w: 152, h: 68 }),
  neutral("review", "Human review", { w: 132, h: 68 }),
]);

const cloud = group("aws", "group_aws_cloud_alt", "AWS Cloud", {
  dir: "col", gap: 30, align: "center", fill: "#FFFFFF",
}, [main, controls, operations]);

const tree = phantom("root", "", { dir: "col", gap: 28, align: "center", header: 0, pad: 18 }, [cloud]);
renderTree(d, tree, [40, 80]);
d.title("AWS FinOps Intelligence with CUDOS v5");

// Evidence → analytics → dashboards.
d.link("billing", "exports", "evidence", { flow: true });
d.link("exports", "s3", "CUR 2.0", { flow: true });
d.link("s3", "glue", "catalog", { flow: true });
d.link("glue", "athena", "query metadata", { flow: true });
d.link("athena", "cudos", "FinOps queries", { flow: true });
d.link("cudos", "quicksight", "dashboards", { flow: true });
d.link("quicksight", "spice", "in-memory cache", { dir: "TB", dash: true });

// Optional conversational layer. The exact Amazon Quick stencil is `quick_suite`.
d.link("quicksight", "ai", "AI context", { dash: true });
d.link("quick", "agent", "chat", { flow: true, dir: "TB" });
d.link("agent", "flows", "automate", { flow: true, dir: "TB" });

// Cross-cutting controls point to each affected component group, keeping the policy
// semantics visible without six parallel lines crossing the primary data spine.
d.link("controls", "financial", "IAM / KMS", { dash: true, role: "fanout" });
d.link("controls", "analytics", "IAM / KMS", { dash: true, role: "fanout" });
d.link("controls", "intelligence", "IAM / KMS", { dash: true, role: "fanout" });

// Detection → approved notification channel → human decision.
d.link("anomaly", "sns", "alert", { flow: true });
d.link("sns", "slack", "notify", { flow: true });
d.link("slack", "review", "review", { flow: true });

const result = d.validate();
console.log("VALIDATE:", JSON.stringify({ ok: result.ok, errors: result.errors, warnings: result.warnings, advice: result.audit.advice }));
const output = new URL("./aws-finops-cudos-architecture-official.drawio", import.meta.url);
writeFileSync(output, d.mxfile("AWS FinOps Intelligence with CUDOS v5"));

// One script run performs the required check render. On Windows use the .cmd shim.
import { execFileSync as __exec } from "node:child_process";
try {
  console.log(__exec("drawio-ai.cmd", ["render", output.pathname, "--check", "-o", output.pathname + ".png"], { encoding: "utf8" }).trim());
} catch (e) {
  console.error("RENDER-SKIPPED:", String(e.message).split("\n")[0]);
}
