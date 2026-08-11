// Evidence-driven FinOps operating loop for section 6.1.
// Built with the drawio-ai layout engine; coordinates are intentionally absent.
import { writeFileSync } from "node:fs";
import { Diagram } from "file:///C:/Users/NGUYENAN/AppData/Roaming/npm/node_modules/drawio-ai-kit/src/builder.mjs";
import { box, frame, group, icon, phantom, renderTree } from "file:///C:/Users/NGUYENAN/AppData/Roaming/npm/node_modules/drawio-ai-kit/src/layout-engine.mjs";

const d = new Diagram("pipeline");

// Neutral boxes are deliberate: these are business concepts or AWS solutions,
// not standalone AWS services with an exact mxgraph.aws4 stencil.
const neutral = (id, label, opts = {}) =>
  box(id, label, {
    w: 154,
    h: 58,
    fill: "#FFFFFF",
    stroke: "#5A6B7B",
    bold: true,
    ...opts,
  });

const signalLane = frame("signal_lane", "Operational signal", {
  dir: "col", gap: 16, align: "center", fill: "#FFFFFF", stroke: "#9AA7B2;dashed=1", dashed: true,
}, [
  neutral("anomaly", "AWS Cost Anomaly\nDetection", { w: 166 }),
  icon("sns", "sns", "Amazon SNS"),
]);

const evidenceLane = frame("evidence_lane", "Financial evidence", {
  dir: "col", gap: 16, align: "center", fill: "#FFFFFF", stroke: "#9AA7B2;dashed=1", dashed: true,
}, [
  icon("cur", "cost_and_usage_report", "CUR 2.0"),
  icon("athena", "athena", "Amazon Athena"),
]);

const detect = frame("detect", "1. Detect & validate", {
  dir: "row", gap: 18, align: "top", fill: "#F7FBFF", stroke: "#1B365D;dashed=1", dashed: true,
}, [signalLane, evidenceLane]);

const assistance = frame("assistance", "Optional AI assistance", {
  dir: "col", gap: 16, align: "center", fill: "#FFFFFF", stroke: "#7A43B6;dashed=1", dashed: true,
}, [
  // quick_suite is the ground-truth current Amazon Quick / Quick Suite stencil.
  icon("quick", "quick_suite", "Amazon Quick"),
  neutral("explain", "Explain approved evidence only\nNo workload-changing authority", { w: 266, h: 68 }),
]);

const analyze = frame("analyze", "2. Analyze & attribute", {
  dir: "col", gap: 18, align: "center", fill: "#F8FBF6", stroke: "#1B365D;dashed=1", dashed: true,
}, [
  neutral("cudos", "CUDOS v5\nFinOps product", { w: 166 }),
  icon("quicksight", "quicksight", "Amazon QuickSight"),
  neutral("driver", "Service · Account · Region\nResource / usage driver", { w: 222, h: 66 }),
  assistance,
]);

const decide = frame("decide", "3. Decide & govern", {
  dir: "col", gap: 18, align: "center", fill: "#FBF8FF", stroke: "#1B365D;dashed=1", dashed: true,
}, [
  neutral("finding", "FinOps finding"),
  neutral("owner", "Workload owner"),
  neutral("approval", "Human approval"),
  neutral("risk", "Risk & rollback"),
]);

const act = frame("act", "4. Act & measure", {
  dir: "col", gap: 16, align: "center", fill: "#FFF9F3", stroke: "#1B365D;dashed=1", dashed: true,
}, [
  neutral("change", "Approved change"),
  neutral("baseline", "Baseline period"),
  neutral("measurement", "Measurement period"),
  neutral("realized", "Realized savings"),
  neutral("retain", "Retain or roll back"),
]);

const main = phantom("main", "", { dir: "row", gap: 28, align: "top", header: 0 }, [
  detect,
  analyze,
  decide,
  act,
]);

const cloud = group("aws", "group_aws_cloud_alt", "AWS Cloud", {
  dir: "col", gap: 34, align: "center", fill: "#FFFFFF",
}, [main]);

const tree = phantom("root", "", { dir: "col", gap: 24, align: "center", header: 0, pad: 16 }, [cloud]);
renderTree(d, tree, [36, 72]);
d.title("Evidence-Driven FinOps Operating Loop");

// Independent operational signal and financial evidence lanes.
d.link("anomaly", "sns", "", { dir: "TB" });
d.link("cur", "athena", "", { dir: "TB" });

// Primary evidence-to-decision-to-measurement flow.
d.link("athena", "cudos", "validated", {});
d.link("cudos", "quicksight", "", { dir: "TB" });
d.link("quicksight", "driver", "", { dir: "TB" });
d.link("driver", "finding", "attributed", {});
d.link("finding", "owner", "", { dir: "TB" });
d.link("owner", "approval", "", { dir: "TB" });
d.link("approval", "risk", "", { dir: "TB" });
d.link("risk", "change", "approved", {});
d.link("change", "baseline", "", { dir: "TB" });
d.link("baseline", "measurement", "", { dir: "TB" });
d.link("measurement", "realized", "", { dir: "TB" });
d.link("realized", "retain", "", { dir: "TB" });

// Alert context and optional AI can inform the finding, never execute remediation.
d.link("sns", "finding", "alert context", { dash: true });
d.link("quicksight", "quick", "optional", { dash: true, dir: "TB" });
d.link("quick", "explain", "explain only", { dash: true, dir: "TB" });

// Measured outcomes close the loop without claiming forecast savings as realized.
d.link("retain", "detect", "measured feedback · next review cycle", { dash: true });

const result = d.validate();
console.log("VALIDATE:", JSON.stringify({
  ok: result.ok,
  errors: result.errors,
  warnings: result.warnings,
  advice: result.audit.advice,
}));

const output = new URL("./evidence-driven-finops-operating-loop.drawio", import.meta.url);
writeFileSync(output, d.mxfile("Evidence-Driven FinOps Operating Loop"));

// When DRAWIO_CLI points to draw.io Desktop, one run also exports a PNG preview.
import { execFileSync as __exec } from "node:child_process";
const drawioCli = process.env.DRAWIO_CLI;
if (drawioCli) {
  try {
    const pngOutput = output.pathname.replace(/\.drawio$/i, ".png");
    console.log(__exec(drawioCli, [
      "-x", "-f", "png", "-e", "-b", "10", "--no-sandbox",
      "-o", pngOutput, output.pathname,
    ], { encoding: "utf8" }).trim());
  } catch (e) {
    console.error("RENDER-SKIPPED:", String(e.message).split("\n")[0]);
  }
} else {
  console.error("RENDER-SKIPPED: set DRAWIO_CLI to the draw.io Desktop executable");
}
