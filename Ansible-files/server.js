// Tiny API: asks Prometheus for web_p's CPU, memory and disk and returns them as JSON.
// No npm packages needed. Written to work on the old Node 12 from Ubuntu's apt.
const http = require("http");

const PROM = process.env.PROMETHEUS_URL || "http://localhost:9090"; // set in the systemd service
const PORT = process.env.PORT || 3000;
const JOB = process.env.JOB || "web_p"; // the job_name in prometheus.yml

const QUERIES = {
  cpu: `100 - avg(rate(node_cpu_seconds_total{job="${JOB}",mode="idle"}[1m])) * 100`,
  memory: `(1 - node_memory_MemAvailable_bytes{job="${JOB}"} / node_memory_MemTotal_bytes{job="${JOB}"}) * 100`,
  disk: `(1 - node_filesystem_avail_bytes{job="${JOB}",mountpoint="/",fstype!="rootfs"} / node_filesystem_size_bytes{job="${JOB}",mountpoint="/",fstype!="rootfs"}) * 100`,
  up: `up{job="${JOB}"}`,
};

function query(promql) {
  return new Promise((resolve, reject) => {
    const url = `${PROM}/api/v1/query?query=${encodeURIComponent(promql)}`;
    http
      .get(url, { timeout: 5000 }, (res) => {
        let body = "";
        res.on("data", (chunk) => (body += chunk));
        res.on("end", () => {
          try {
            const result = JSON.parse(body).data.result;
            resolve(result.length ? Number(result[0].value[1]) : null);
          } catch (e) {
            reject(e);
          }
        });
      })
      .on("error", reject)
      .on("timeout", function () {
        this.abort();
      });
  });
}

const round = (n) => (n === null || isNaN(n) ? null : Math.round(n * 10) / 10);

http
  .createServer(async (req, res) => {
    const send = (code, obj) => {
      res.writeHead(code, { "Content-Type": "application/json" });
      res.end(JSON.stringify(obj));
    };
    if (req.method === "GET" && req.url.split("?")[0] === "/api/metrics/current") {
      try {
        const [cpu, memory, disk, up] = await Promise.all([
          query(QUERIES.cpu), query(QUERIES.memory), query(QUERIES.disk), query(QUERIES.up),
        ]);
        send(200, { cpu: round(cpu), memory: round(memory), disk: round(disk), status: up === 1 ? "up" : "down" });
      } catch (e) {
        send(502, { error: "Cannot reach Prometheus" });
      }
    } else {
      send(404, { error: "Not found" });
    }
  })
  .listen(PORT, "127.0.0.1", () => console.log(`API on port ${PORT}, Prometheus at ${PROM}`));