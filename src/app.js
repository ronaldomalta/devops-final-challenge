const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const rateLimit = require('express-rate-limit');
const swaggerUi = require('swagger-ui-express');

const swaggerSpec = require('./config/swagger');
const env = require('./config/env');
const routes = require('./routes');
const errorHandler = require('./middlewares/error-handler');
const notFound = require('./middlewares/not-found');

// Observabilidade
const {
  register,
  metricsMiddleware,
} = require('./monitoring/metrics');

const app = express();

// ======================================================
// OBSERVABILIDADE
// ======================================================

// Middleware responsável por medir as requisições HTTP
app.use(metricsMiddleware);

// ======================================================
// SEGURANÇA
// ======================================================

// Security headers
app.use(helmet());

// CORS
app.use(cors());

// Rate limiting
if (!env.isTest()) {
  const limiter = rateLimit({
    windowMs: env.rateLimit.windowMs,
    max: env.rateLimit.max,
    standardHeaders: true,
    legacyHeaders: false,
    message: {
      status: 'error',
      code: 'RATE_LIMIT_EXCEEDED',
      message: 'Too many requests, please try again later',
    },
  });

  // O endpoint /metrics não passa pelo rate limit,
  // pois o Prometheus precisa consultá-lo continuamente.
  app.use((req, res, next) => {
    if (req.path === '/metrics') {
      return next();
    }

    return limiter(req, res, next);
  });
}
// ======================================================
// BODY PARSING
// ======================================================

app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true }));

// ======================================================
// SWAGGER
// ======================================================

app.use(
  '/api-docs',
  swaggerUi.serve,
  swaggerUi.setup(swaggerSpec, {
    customCss: '.swagger-ui .topbar { display: none }',
    customSiteTitle: 'E-Commerce API Docs',
  })
);

app.get('/api-docs.json', (req, res) => {
  res.setHeader('Content-Type', 'application/json');
  res.send(swaggerSpec);
});

// ======================================================
// HEALTH CHECK
// ======================================================

app.get('/health', (req, res) => {
  res.json({
    status: 'ok',
    timestamp: new Date().toISOString(),
    uptime: process.uptime(),
  });
});

// ======================================================
// PROMETHEUS METRICS
// ======================================================

app.get('/metrics', async (req, res) => {
  try {
    res.set('Content-Type', register.contentType);
    res.end(await register.metrics());
  } catch (error) {
    res.status(500).end(error.message);
  }
});

// ======================================================
// API ROUTES
// ======================================================

app.use('/api/v1', routes);

// ======================================================
// ERROR HANDLERS
// ======================================================

// 404 handler for unmatched routes
app.use(notFound);

// Global error handler
app.use(errorHandler);

module.exports = app;