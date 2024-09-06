const express = require('express');
const fs = require('fs/promises');
const path = require('path');
const cors = require('cors');

const app = express();
const port = 3000;

app.use(cors());

// Utility function to handle file reading and parsing JSON
const getData = async (filePath, res) => {
  try {
    const data = await fs.readFile(filePath, 'utf8');
    res.json(JSON.parse(data));
  } catch (error) {
    console.error(`Error reading ${filePath}:`, error);
    res.status(500).send(`Error reading ${filePath}`);
  }
};

// Get all messages for every user
const getAllMessages = async (res) => {
    try {
        const inboxDirPath = path.join(__dirname, 'Data/your_instagram_activity/messages/inbox');
        const allMessages = {};

        // Read all user directories in the inbox
        const users = await fs.readdir(inboxDirPath);

        for (const user of users) {
            const userDirPath = path.join(inboxDirPath, user);

            // Skip if it's not a directory
            const stat = await fs.lstat(userDirPath);
            if (!stat.isDirectory()) {
                continue;
            }

            const userMessages = [];

            // Read all files in the user's directory
            const files = await fs.readdir(userDirPath);

            for (const file of files) {
                const filePath = path.join(userDirPath, file);
                const fileStat = await fs.lstat(filePath);

                // Skip if it's not a file
                if (fileStat.isFile()) {
                    const message = JSON.parse(await fs.readFile(filePath, 'utf8'));
                    userMessages.push(message);
                }
            }

            // Add the user's messages to the allMessages object
            allMessages[user] = userMessages;
        }

        // Send the aggregated messages as the response
        res.json(allMessages);
    } catch (error) {
        console.error(`Error reading inbox directory:`, error);
        res.status(500).send(`Error reading inbox directory`);
    }
};

const getCommentData = async (personId, res) => {
    try {
        
        const filePath = path.join(__dirname, 'Data/your_instagram_activity/messages/inbox', personId, 'message_1.json');
        
        
        const data = await fs.readFile(filePath, 'utf8');
        const parsedData = JSON.parse(data);
    
        
        if (!Array.isArray(parsedData.messages) || parsedData.messages.length === 0) {
          return res.status(400).send('No messages found');
        }
    
        
        const messages = parsedData.messages.map(msg => ({
          sender: msg.sender_name,
          content: msg.content || 'No content', 
          timestamp: msg.timestamp_ms,
          reactions: msg.reactions || [],
          share: msg.share || null
        }));
    
        
        res.json({ participants: parsedData.participants, messages });
      } catch (error) {
        console.error(`Error reading message file:`, error);
        res.status(500).send('Error reading message file');
      }
  };


// Routes
app.get('/', (req, res) => {
  res.send('Instagram API');
});

app.get('/api/profile', (req, res) => {
  const filePath = path.join(__dirname, 'Data', 'personal_information.json');
  getData(filePath, res);
});

app.get('/api/media', async (req, res) => {
  try {
    const mediaPath = path.join(__dirname, 'Data/media/posts');
    const files = await fs.readdir(mediaPath);
    
    const imageFiles = files.filter(file => ['.jpg', '.png'].includes(path.extname(file).toLowerCase()));
    
    res.json({ imageFiles });
  } catch (error) {
    console.error('Error fetching image files:', error);
    res.status(500).send('Error fetching image files');
  }
});

app.get('/api/comments/reel', (req, res) => {
  const filePath = path.join(__dirname, 'Data/your_instagram_activity/comments', 'reels_comments.json');
  getData(filePath, res);
});

app.get('/api/comments/post', (req, res) => {
  const filePath = path.join(__dirname, 'Data/your_instagram_activity/comments', 'post_comments_1.json');
  getData(filePath, res);
});

app.get('/api/content/archivePosts', (req, res) => {
  const filePath = path.join(__dirname, 'Data/your_instagram_activity/content', 'archive_posts.json');
  getData(filePath, res);
});

app.get('/api/likes/comments', (req, res) => {
  const filePath = path.join(__dirname, 'Data/your_instagram_activity/likes', 'liked_comments.json');
  getData(filePath, res);
});

app.get('/api/likes/posts', (req, res) => {
  const filePath = path.join(__dirname, 'Data/your_instagram_activity/likes', 'liked_posts.json');
  getData(filePath, res);
});

app.get('/api/messages', (req, res) => {
  getAllMessages(res);
});


app.get('/api/messages/:name', (req, res) => {
    const name = req.params.name; 
    getCommentData(name, res);    
  });


// Start the server
app.listen(port, () => {
  console.log(`Server started on localhost:${port}`);
});
