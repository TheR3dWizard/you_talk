// basic express app
import express from 'express';
import bodyParser from 'body-parser';
import cors from 'cors';
import mongoose from 'mongoose';
import dotenv from 'dotenv';
import { geminiController } from './gemini.controller.js';

dotenv.config();

const app = express();
app.use(cors());
app.use(bodyParser.json());

app.get('/', (req, res) => {
    res.send('Hello World');
});

app.get('/generate', geminiController.generateContent);

const PORT = process.env.PORT || 6000;

app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});
