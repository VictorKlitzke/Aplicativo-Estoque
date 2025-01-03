import express from 'express';
import cors from 'cors';
import router from "./routers/index";
import bodyParser from "body-parser";
import cookieParser from "cookie-parser";
const app = express();

const corsOptions = {
    origin: 'http://192.168.1.6:3001',
    credentials: true,
    optionsSuccessStatus: 200,
};


app.use(cors());
app.use(cors(corsOptions))
app.use(bodyParser.json())
app.use(cookieParser())
app.use(express.json())
app.use('/api', router)


export default app;