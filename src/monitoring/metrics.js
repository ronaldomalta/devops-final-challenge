const client = require('prom-client');

// Registro das métricas
const register = new client.Registry();

// Métricas padrão do Node.js:
// CPU, memória, event loop, garbage collector etc.
client.collectDefaultMetrics({
  register,
});

// Total de requisições HTTP
const httpRequestsTotal = new client.Counter({
  name: 'http_requests_total',
  help: 'Total de requisicoes HTTP recebidas',
  labelNames: ['method', 'route', 'status_code'],
  registers: [register],
});

// Tempo de resposta das requisições
const httpRequestDuration = new client.Histogram({
  name: 'http_request_duration_seconds',
  help: 'Duracao das requisicoes HTTP em segundos',
  labelNames: ['method', 'route', 'status_code'],
  buckets: [0.01, 0.05, 0.1, 0.3, 0.5, 1, 2, 5],
  registers: [register],
});

// Middleware que mede cada requisição
function metricsMiddleware(req, res, next) {
  const start = process.hrtime.bigint();

  res.on('finish', () => {
    // Não contabiliza o próprio endpoint de métricas
    if (req.path === '/metrics') {
      return;
    }

    const end = process.hrtime.bigint();
    const duration = Number(end - start) / 1e9;

    const route = req.route?.path || req.path;

    httpRequestsTotal.inc({
      method: req.method,
      route,
      status_code: res.statusCode,
    });

    httpRequestDuration.observe(
      {
        method: req.method,
        route,
        status_code: res.statusCode,
      },
      duration
    );
  });

  next();
}

module.exports = {
  register,
  metricsMiddleware,
};