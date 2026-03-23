/**
 * HTTP Cloud Function.
 * It should accept req (request) and res (response) objects because you are using --trigger-http.
 *
 * @param {Object} req Cloud Function request context.
 * @param {Object} res Cloud Function response context.
 */

const functions = require('@google-cloud/functions-framework');

functions.http('helloWorld', (req, res) => {
  console.log('Function triggered!');

  // Get the name from the query parameters or use the default "World"
  const name = req.query.name || req.body.name || 'World';

  res.status(200).send(`Hello ${name}! Built and deployed via Cloud Build v3.0.0 - Canary Deployment test.`);
});
