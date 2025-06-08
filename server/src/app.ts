import express from 'express';
import cors from 'cors';

import { applyRouters } from './routes/index.js';


export function startApp() {
    const PORT = process.env.PORT;
    const IS_DEV = process.env.IS_DEV;
    const SECRET = process.env.SECRET ?? "";

    const app = express();

    if (IS_DEV) app.use(cors({
        credentials: true
    }));
    app.use(express.json());
    app.use(express.urlencoded());
    applyRouters(app);

    app.listen(PORT, () => {
        console.log(`SD Helper Server Opened on Port : ${PORT}`);
    });
}