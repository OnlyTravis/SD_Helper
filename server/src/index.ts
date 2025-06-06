import expressSession from 'express-session';
import express from 'express';
import dotenv from 'dotenv';
import cors from 'cors';
import { applyRouters } from './routes/index';

dotenv.config();
const PORT = process.env.PORT;
const IS_DEV = process.env.IS_DEV;
const SECRET = process.env.SECRET ?? "";

const app = express();
if (IS_DEV) app.use(cors());
app.use(express.json());
app.use(expressSession({
    secret: SECRET,
}));
applyRouters(app);

app.listen(PORT, () => {
    console.log(`SD Helper Server Opened on Port : ${PORT}`);
});