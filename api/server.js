const express = require('express');
const path = require('path');
const app = express();

// In-memory log storage (for demo purposes, you could use a file or database in production)
const logs = []; 

// Define the directory where the image is stored
const imageDirectory = path.join(__dirname, 'public'); // Assuming public/ is in the root directory

// Serve static files (including images) from the public directory
app.use(express.static(imageDirectory));

// Log and serve the image route
app.get('/track-image.png', (req, res) => {
  const clientIp = req.headers['x-forwarded-for'] || req.connection.remoteAddress;
  const logMessage = `Image requested by IP: ${clientIp}`;
  logs.push(logMessage);
  console.log(logMessage); // Logs will appear in the server logs

  // Serve the image file
  res.sendFile(path.join(imageDirectory, 'track-image.png'));
});

// Home route to display logs (optional)
app.get('/', (req, res) => {
  res.send(`
    <h1>Access Logs</h1>
    <pre>${logs.join('\n')}</pre>
  `);
});

// Ensure the app listens on the port provided by the environment (for production on Railway)
const port = process.env.PORT || 3000;
app.listen(port, () => {
  console.log(`Server is running at http://localhost:${port}`);
});
