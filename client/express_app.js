// THIS FILE IS REQUIRED FOR WEB APP DEPLOY - DO NOT DELETE OR RENAME!!!

const express = require('express');
const path = require('path');

const app = express();
const port = 3000; // Choose a port number

// Serve static files from the Flutter web build directory
app.use(express.static(path.join(__dirname, 'build', 'web')));

// Serve index.html for all other routes
app.get('*', (req, res) => {
  res.sendFile(path.join(__dirname, 'build', 'web', 'index.html'));
});

// Start the server
app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});

module.exports = app;
