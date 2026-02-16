const functions = require("firebase-functions");
const axios = require("axios");

exports.apiProxy = functions.https.onRequest(async (req, res) => {
  try {
    const url = "http://18.208.248.234:3000" + req.url;

    const response = await axios({
      method: req.method,
      url: url,
      data: req.body,
      headers: req.headers,
    });

    res.status(response.status).send(response.data);
  } catch (error) {
    console.error(error.message);
    res.status(500).send("Proxy error");
  }
});
